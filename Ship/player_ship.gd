extends CharacterBody3D
class_name PlayerShip

@onready var rotation_pivot: Node3D = $RotationPivot
@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var weapons_node: Node3D = $RotationPivot/Weapons
@onready var hurtbox: Area3D = $HurtBox
@onready var dodge_timer: Timer = $Utilities/DodgeTimer
@onready var invuln_timer: Timer = $Utilities/InvulTimer
@onready var ship_mod_manager: ShipModManager = ShipModManager.new()

@export var base_stats: ShipStats
@export var shipsize : Vector3 = Vector3(1,1,1)
var stats: ShipStats

var weapons: Array[Weapon] = []
var current_weapon_index: int = 0
var can_dodge: bool = true
var is_invulnerable: bool = false
var level : Level = null

var current_hull: float
var current_shield: float
var current_power: float

func _ready() -> void:
	stats = ShipStats.new()
	
	current_hull = stats.max_hull
	current_shield = stats.max_shield
	current_power = stats.max_power
	
	# Grab all weapons under Weapons node
	for weapon in weapons_node.get_children():
		if weapon is Weapon:
			weapons.append(weapon)
			weapon.initialize()  # Setup timers in weapon
	# Re-apply mods after weapons are loaded
	ship_mod_manager.update_stats(self)
	
	level = GameManager.current_level

func _physics_process(delta: float) -> void:
	# Movement: Accelerate towards input dir
	var move_input: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	if move_input != Vector2.ZERO:
		velocity = velocity.move_toward(Vector3(move_input.x, 0, move_input.y) * stats.top_speed, stats.acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, stats.acceleration * delta)
	move_and_slide()
	# Clamp to play area
	var bounds = level.get_play_bounds()
	global_position.x = clamp(global_position.x, bounds.min_x + shipsize.x, bounds.max_x - shipsize.x)
	global_position.z = clamp(global_position.z, bounds.min_z + shipsize.z, bounds.max_z - shipsize.z)
	
	# Aiming: Lerp rotation_pivot towards aim dir
	if camera:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
		var ray_dir: Vector3 = camera.project_ray_normal(mouse_pos)
		var plane: Plane = Plane(Vector3(0, 1, 0), 0)
		var aim_point: Variant = plane.intersects_ray(ray_origin, ray_dir)
		if aim_point:
			var look_dir: Vector3 = (aim_point - global_position).normalized()
			var target_rot_y = atan2(look_dir.x, look_dir.z) - PI
			rotation_pivot.rotation.y = lerp_angle(rotation_pivot.rotation.y, target_rot_y, stats.turn_rate * delta)
	
	# Fire weapons, cycling through if power is low
	if Input.is_action_pressed("fire_primary") and weapons.size() > 0:
		var start_index = current_weapon_index
		var try_count = 0
		while try_count < weapons.size():
			var weapon = weapons[current_weapon_index]
			if weapon.can_fire and current_power >= weapon.wstat.power_cost:
				weapon.shoot(rotation_pivot.rotation.y)
				current_power -= weapon.wstat.power_cost
				current_weapon_index = (current_weapon_index + 1) % weapons.size()
				break
			current_weapon_index = (current_weapon_index + 1) % weapons.size()
			try_count += 1
			if try_count >= weapons.size() and current_weapon_index == start_index:
				break  # Avoid infinite loop if no weapon can fire
	
	# Regens
	current_power = min(current_power + stats.power_regen * delta, stats.max_power)
	current_shield = min(current_shield + stats.shield_regen * delta, stats.max_shield)

func dodge(direction: Vector2) -> void:
	if not can_dodge or direction == Vector2.ZERO:
		var angle = rotation_pivot.rotation.y
		direction = Vector2(-sin(angle), cos(angle))
	var dodge_vector: Vector3 = Vector3(direction.x, 0, direction.y).normalized() * stats.dodge_length
	velocity += dodge_vector / stats.dodge_cooldown
	is_invulnerable = true
	can_dodge = false
	invuln_timer.start(stats.dodge_invuln)
	dodge_timer.start(stats.dodge_cooldown)

func _on_dodge_timer_timeout() -> void:
	can_dodge = true

func _on_invul_timer_timeout() -> void:
	is_invulnerable = false

func _on_hurtbox_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(GameData.collision_damage)
	if is_invulnerable:
		return
	if body.is_in_group("terrain"):
		take_damage(GameData.collision_damage)
	elif body.is_in_group("enemies"):
		take_damage(GameData.collision_damage)

func take_damage(amount: float) -> void:
	var damage_after_armor = amount * (1.0 - stats.hull_armor)
	current_hull = max(0, current_hull - damage_after_armor)
	if current_hull <= 0:
		die()

func die() -> void:
	print("Player died!")
	await get_tree().create_timer(2.0).timeout
	PlayerData.save_player_data()
	level.player_death()
