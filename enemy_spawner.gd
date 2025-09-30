extends Node3D
class_name EnemySpawner

signal spawner_empty

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_interval: float = 1.0
@export var max_spawns: int = 3

@onready var timer: Timer = Timer.new()
@onready var spawn_area: EnemySpawner = $"."

var level: Level = null  # Cache for room access
var spawned: int = 0

func _ready() -> void:
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_enemy)
	if enemy_scenes.is_empty():
		push_error("No enemy scenes assigned to EnemySpawner!")
		return
	# Don't start timer here—wait for activate
	level = get_tree().current_scene as Level

func activate() -> void:
	if not timer.is_stopped():
		return  # Prevent double-start
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
	level.current_room.add_child(enemy)  # Parent to room for easy cleanup
	enemy.global_position = spawn_pos
	
	spawned += 1
	if level and level.current_room:
		level.current_room.enemies_remaining += 1  # Increment on actual spawn
	
	enemy.activate()  # Wake it up immediately
	
	if spawned >= max_spawns:
		spawner_empty.emit()
		queue_free()

func destroy() -> void:
	queue_free()
