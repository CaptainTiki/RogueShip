extends Enemy
class_name PatternEnemy

@export var pattern_script: PatternBehavior
@export var attack_interval: float = 2.0

@onready var attack_timer: Timer = $AttackTimer
@onready var weapons_node: Node3D = $RotationPivot/Weapons

var time: float = 0.0
var weapons: Array[Weapon] = []

func _ready() -> void:
	super._ready()
	print("PatternEnemy ", name, " initialized with pattern: ", pattern_script.resource_path if pattern_script else "none")
	for weapon in weapons_node.get_children():
		if weapon is Weapon:
			weapons.append(weapon)
			weapon.initialize()
			print("PatternEnemy ", name, " added weapon: ", weapon.name)
	attack_timer.wait_time = attack_interval
	attack_timer.one_shot = true
	attack_timer.stop()

func activate() -> void:
	super.activate()
	print("PatternEnemy ", name, " activated, starting attack timer")
	attack_timer.start()

func _physics_process(delta: float) -> void:
	if not pattern_script:
		printerr("ERROR: No pattern assigned for enemy ", name)
		return
	time += delta
	pattern_script.run(self, delta)
	if attack_timer.time_left == 0:
		print("PatternEnemy ", name, " performing attack")
		_perform_attack()
		attack_timer.start()
	move_and_slide()

func _perform_attack() -> void:
	print("PatternEnemy ", name, " shooting with ", weapons.size(), " weapons")
	for weapon in weapons:
		weapon.shoot(0)

func _on_hurtbox_body_entered(body: Node3D) -> void:
	print("PatternEnemy ", name, " HurtBox collided with: ", body.name, " in group: ", body.get_groups())
	if body.is_in_group("terrain"):
		print("PatternEnemy ", name, " hit terrain, taking damage: ", GameData.collision_damage)
		take_damage(GameData.collision_damage)

func _on_hit_box_area_entered(area: Area3D) -> void:
	print("PatternEnemy ", name, " HitBox area entered: ", area.name, " in group: ", area.get_groups())
