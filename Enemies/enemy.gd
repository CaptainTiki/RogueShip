extends CharacterBody3D
class_name Enemy

@export var max_hull: float = 30.0
@export var speed: float = 5.0
@export var attack_range: float = 20.0
@export var flee_threshold: float = 0.25
@export var turn_rate: float = 5.0
@export var behavior: EnemyBehavior  # Custom behavior script

@onready var hurtbox: Area3D = $HurtBox
@onready var attack_timer: Timer = $AttackTimer
@onready var stagger_timer: Timer = $StaggerTimer
@onready var weapons_node: Node3D = $RotationPivot/Weapons
@onready var rotation_pivot: Node3D = $RotationPivot

var hull: float
var current_state: String = "pursue"  # pursue, attack, flee
var target: Node3D = null
var is_staggered: bool = false
var weapons: Array[Weapon] = []
var current_weapon_index: int = 0

func _ready() -> void:
	hull = max_hull
	target = PlayerData.ship_instance
	if not behavior:
		print("ERROR: No behavior assigned for enemy ", name)
	else:
		# Grab all weapons under Weapons node
		for weapon in weapons_node.get_children():
			if weapon is Weapon:
				weapons.append(weapon)
				weapon.initialize()  # Setup timers in weapon
	attack_timer.start()

func _physics_process(delta: float) -> void:
	if not target or is_staggered:
		velocity = Vector3.ZERO
		print("No target or staggered: ", name, " | Target: ", target, " | Staggered: ", is_staggered)
		return
	_update_state()
	# Rotate to face target
	var dir = (target.global_position - global_position).normalized()
	var target_rot_y = atan2(dir.x, dir.z) - PI
	$RotationPivot.rotation.y = lerp_angle($RotationPivot.rotation.y, target_rot_y, turn_rate * delta)
	print("Enemy: ", name, " | Rot Y: ", $RotationPivot.rotation.y, " | Target Rot: ", target_rot_y)
	# Run behavior
	if behavior:
		behavior.run(self, delta)
	move_and_slide()

func _update_state() -> void:
	var dist_to_target = global_position.distance_to(target.global_position)
	print("Enemy: ", name, " | Dist to target: ", dist_to_target, " | State: ", current_state, " | Hull: ", hull)
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
	print("Hurtbox hit by: ", body.name, " | Groups: ", body.get_groups())
	if body.is_in_group("terrain"):
		take_damage(GameData.collision_damage)

func take_damage(amount: float) -> void:
	print("Enemy hit: ", name, " | Damage: ", amount, " | Hull left: ", hull - amount)
	hull = max(0, hull - amount)
	if hull > 0:
		is_staggered = true
		stagger_timer.start(0.25)
	if hull <= 0:
		die()

func die() -> void:
	print("Enemy died: ", name, " | Hull was: ", hull)
	if randf() < 0.1:
		var pickup = preload("res://Mods/ModPickup.tscn").instantiate()
		pickup.mod = ModManager.get_random_unlocked_mod()
		get_tree().root.add_child(pickup)
		pickup.global_position = global_position
	if get_tree().current_scene is Level:
		get_tree().current_scene.enemy_killed()
	queue_free()

func _on_attack_timeout() -> void:
	pass

func _on_stagger_timeout() -> void:
	is_staggered = false
