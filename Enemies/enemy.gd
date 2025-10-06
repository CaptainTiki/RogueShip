extends CharacterBody3D
class_name Enemy

signal destroyed

@export var max_hull: float = 30.0
@export var speed: float = 5.0
@export var on_destroy_script: OnDestroy

var hull: float

func _ready() -> void:
	hull = max_hull
	set_physics_process(false)
	print("BaseEnemy spawned: ", name, " at position: ", global_position)

func activate() -> void:
	set_physics_process(true)
	print("BaseEnemy activated: ", name, " at position: ", global_position)

func take_damage(amount: float) -> void:
	print("BaseEnemy ", name, " taking damage: ", amount, " at position: ", global_position)
	hull = max(0, hull - amount)
	if hull <= 0:
		print("BaseEnemy ", name, " hull depleted, calling die_scored")
		die_scored()

func die_scored() -> void:
	print("BaseEnemy ", name, " die_scored at position: ", global_position)
	if on_destroy_script:
		print("BaseEnemy ", name, " handling destroy script")
		on_destroy_script.handle_destroy(self)
	if get_tree().current_scene is Level:
		print("BaseEnemy ", name, " notifying level of death")
		get_tree().current_scene.enemy_killed()
	destroyed.emit()
	queue_free()

func die_unscored() -> void:
	print("BaseEnemy ", name, " die_unscored at position: ", global_position)
	if get_tree().current_scene is Level:
		print("BaseEnemy ", name, " notifying level of death")
		get_tree().current_scene.enemy_killed()
	destroyed.emit()
	queue_free()
