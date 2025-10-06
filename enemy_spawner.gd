@tool
extends Node3D
class_name EnemySpawner

signal spawner_empty

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_interval: float = 1.0
@export var max_spawns: int = 3
@export var wave_mode: bool = false
@export var wave_size: int = 3
@export var wave_separation: float = 1.0
@export_group("Editor Pattern Preview")
@export var preview_speed: float = 1.0
@export var preview_duration: float = 10.0  # How long to simulate path (seconds)

@onready var timer: Timer = Timer.new()
@onready var spawn_area: EnemySpawner = $"."

var level: Level = null
var spawned: int = 0
var debug_mesh: MeshInstance3D
var preview_enemies: Array[Enemy] = []

func _ready() -> void:
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_enemy)
	if enemy_scenes.is_empty():
		push_error("No enemy scenes assigned to EnemySpawner!")
		return
	level = get_tree().current_scene as Level
	if not Engine.is_editor_hint():
		print("EnemySpawner initialized at position: ", global_position)
		_clear_preview_enemies()  # Ensure no preview enemies in game
	else:
		debug_mesh = MeshInstance3D.new()
		debug_mesh.name = "DebugMesh"
		debug_mesh.mesh = ImmediateMesh.new()
		debug_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(debug_mesh)
		debug_mesh.owner = get_tree().edited_scene_root
		_setup_preview_enemies()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		_clear_preview_enemies()

func activate() -> void:
	if not Engine.is_editor_hint():
		print("EnemySpawner activated at position: ", global_position)
		if not timer.is_stopped():
			return
		timer.start()

func spawn_enemy() -> void:
	if not spawn_area:
		push_error("No SpawnArea found!")
		return
	var collision_shape = spawn_area.get_node("CollisionShape3D")
	if not collision_shape or not collision_shape.shape is BoxShape3D:
		push_error("SpawnArea needs a BoxShape3D!")
		return
	var box_shape = collision_shape.shape as BoxShape3D
	var extents = box_shape.size / 2.0
	
	if wave_mode:
		var enemies_to_spawn = min(wave_size, max_spawns - spawned)
		var enemy_scene = enemy_scenes[0]  # Use first (and only) scene
		for i in range(enemies_to_spawn):
			var enemy = enemy_scene.instantiate() as Enemy
			level.current_room.add_child(enemy)
			enemy.global_position = Vector3(global_position.x + (wave_separation * i), global_position.y, global_position.z)
			if not Engine.is_editor_hint():
				print("Spawning ", enemy.name, " at position: ", enemy.global_position)
			enemy.activate()
			spawned += 1
			level.current_room.enemies_remaining += 1
		if spawned >= max_spawns:
			spawner_empty.emit()
			queue_free()
		else:
			timer.start()
	else:
		var enemy_scene = enemy_scenes[0]  # Use first (and only) scene
		var enemy = enemy_scene.instantiate() as Enemy
		level.current_room.add_child(enemy)
		var random_offset = Vector3(
			randf_range(-extents.x, extents.x),
			0,
			randf_range(-extents.z, extents.z)
		)
		enemy.global_position = global_position + random_offset
		if not Engine.is_editor_hint():
			print("Spawning ", enemy.name, " at position: ", enemy.global_position)
		enemy.activate()
		spawned += 1
		level.current_room.enemies_remaining += 1
		if spawned >= max_spawns:
			spawner_empty.emit()
			queue_free()

func _setup_preview_enemies() -> void:
	if not Engine.is_editor_hint():
		return  # Don't create preview enemies in game
	_clear_preview_enemies()
	if enemy_scenes.is_empty() or not enemy_scenes[0]:
		return
	var enemy_scene = enemy_scenes[0]
	for i in range(wave_size):
		var enemy = enemy_scene.instantiate() as Enemy
		enemy.name = "PreviewEnemy_" + str(i)
		enemy.global_position = Vector3(global_position.x + (wave_separation * i), global_position.y, global_position.z)
		add_child(enemy)
		enemy.owner = get_tree().edited_scene_root
		enemy.set_physics_process(false)  # Keep static
		preview_enemies.append(enemy)

func _clear_preview_enemies() -> void:
	for enemy in preview_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	preview_enemies.clear()

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	if not debug_mesh or not debug_mesh.mesh is ImmediateMesh:
		return
	if enemy_scenes.is_empty() or not enemy_scenes[0]:
		return
	
	var mesh: ImmediateMesh = debug_mesh.mesh
	mesh.clear_surfaces()
	
	var enemy_scene = enemy_scenes[0]
	var test_enemy = enemy_scene.instantiate() as Enemy
	var pattern = null
	if test_enemy is PatternEnemy:
		pattern = (test_enemy as PatternEnemy).pattern_script
	test_enemy.queue_free()
	
	if not pattern:
		return
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0)
	material.flags_unshaded = true
	
	var steps: int = 100
	var time_step: float = preview_duration / steps
	
	for i in range(wave_size):
		var start_pos = Vector3(global_position.x + (wave_separation * i), global_position.y, global_position.z)
		var prev_point: Vector3 = start_pos
		mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
		
		for j in range(steps):
			var t = j * time_step
			var point: Vector3
			if pattern is SineWavePattern:
				var offset = sin(t * pattern.frequency) * pattern.amplitude
				point = start_pos + Vector3(offset, 0, t * preview_speed)
			else:
				# Fallback: straight line in positive Z
				point = start_pos + Vector3(0, 0, t * preview_speed)
			mesh.surface_add_vertex(prev_point)
			mesh.surface_add_vertex(point)
			prev_point = point
		
		mesh.surface_end()
