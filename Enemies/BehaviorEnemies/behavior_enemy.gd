extends Enemy
class_name BehaviorEnemy

@export var attack_range: float = 20.0
@export var flee_threshold: float = 0.25
@export var turn_rate: float = 5.0
@export var behavior: EnemyBehavior  # Custom behavior script

@export var is_elite: bool = false
@export var is_mini_boss: bool = false
@export var is_boss: bool = false

@onready var hurtbox: Area3D = $HurtBox
@onready var attack_timer: Timer = $AttackTimer
@onready var stagger_timer: Timer = $StaggerTimer
@onready var weapons_node: Node3D = $RotationPivot/Weapons
@onready var rotation_pivot: Node3D = $RotationPivot

var current_state: String = "pursue"  # pursue, attack, flee
var target: Node3D = null
var is_staggered: bool = false
var weapons: Array[Weapon] = []
var current_weapon_index: int = 0

func _ready() -> void:
	hull = max_hull
	target = PlayerData.ship_instance
	if not behavior:
		printerr("ERROR: No behavior assigned for enemy ", name)
	else:
		for weapon in weapons_node.get_children():
			if weapon is Weapon:
				weapons.append(weapon)
				weapon.initialize()
	set_physics_process(false)  # Dormant
	attack_timer.stop()  # Ensure off

func activate() -> void:
	set_physics_process(true)
	attack_timer.start()

func _physics_process(delta: float) -> void:
	if not target or is_staggered:
		velocity = Vector3.ZERO
		return
	_update_state()
	# Rotate to face target
	var dir = (target.global_position - global_position).normalized()
	var target_rot_y = atan2(dir.x, dir.z) - PI
	$RotationPivot.rotation.y = lerp_angle($RotationPivot.rotation.y, target_rot_y, turn_rate * delta)
	# Run behavior
	if behavior:
		behavior.run(self, delta)
	move_and_slide()

func _update_state() -> void:
	var dist_to_target = global_position.distance_to(target.global_position)
	if hull / max_hull < flee_threshold:
		current_state = "flee"
	elif dist_to_target <= attack_range:
		current_state = "attack"
	else:
		current_state = "pursue"

func _perform_attack() -> void:
	for index in weapons.size():
		var weapon = weapons[index]
		weapon.shoot(rotation_pivot.rotation.y)
	attack_timer.start()

func _on_hurtbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("terrain"):
		take_damage(GameData.collision_damage)

func take_damage(amount: float) -> void:
	hull = max(0, hull - amount)
	if hull > 0:
		is_staggered = true
		stagger_timer.start(0.25)
	if hull <= 0:
		die_scored()

func die_scored() -> void:
	if on_destroy_script:
		on_destroy_script.handle_destroy(self)
	else:
		# Default grunt behavior
		if randf() < 0.75:  # Existing drop chance
			var pickup = preload("res://Pickups/ModPickup.tscn").instantiate()
			pickup.mod = ModManager.get_random_unlocked_mod()
			get_tree().root.add_child(pickup)
			pickup.global_position = global_position
	if get_tree().current_scene is Level:
		get_tree().current_scene.enemy_killed()  # Decrement count
	destroyed.emit()
	queue_free()

func die_unscored() -> void:
	if get_tree().current_scene is Level:
		get_tree().current_scene.enemy_killed()  # Still decrement for clear
	destroyed.emit()
	queue_free()

func _on_attack_timeout() -> void:
	pass

func _on_stagger_timeout() -> void:
	is_staggered = false
