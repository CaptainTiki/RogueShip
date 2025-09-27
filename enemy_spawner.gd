extends Node3D
class_name EnemySpawner

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_interval: float = 5.0
@export var max_spawns: int = 3

@onready var timer: Timer = Timer.new()
@onready var spawn_area: Area3D = $SpawnArea

var spawned: int = 0

func _ready() -> void:
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_enemy)
	if enemy_scenes.is_empty():
		push_error("No enemy scenes assigned to EnemySpawner!")
		return
	timer.start()

func spawn_enemy() -> void:
	if not spawn_area:
		push_error("No SpawnArea found in EnemySpawner!")
		return
	
	# Get the BoxShape3D from SpawnArea
	var collision_shape = spawn_area.get_node("CollisionShape3D")
	if not collision_shape or not collision_shape.shape is BoxShape3D:
		push_error("SpawnArea needs a BoxShape3D!")
		return
	
	var box_shape = collision_shape.shape as BoxShape3D
	var extents = box_shape.size / 2.0
	
	# Random position within box, relative to spawner's global position
	var random_offset = Vector3(
		randf_range(-extents.x, extents.x),
		0,
		randf_range(-extents.z, extents.z)
	)
	var spawn_pos = global_position + random_offset
	
	# Pick random enemy scene
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = enemy_scene.instantiate() as Enemy
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawn_pos
	print("Spawned enemy: ", enemy.name, " | Type: ", enemy_scene.resource_path)
	
	spawned += 1
	if spawned >= max_spawns:
		queue_free()
