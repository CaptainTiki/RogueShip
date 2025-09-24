extends CharacterBody3D
class_name PlayerShip

@export var base_speed: float = 20.0  # Pixels/sec
@export var base_damage: float = 10.0  # Per bullet
@export var fire_rate: float = 0.2  # Seconds between shots
@export var dodge_distance: float = 20.0  # Dash length
@export var dodge_cooldown: float = 1.0  # Seconds
@export var dodge_invuln_time: float = 0.3  # Invuln during dash

var speed: float = base_speed
var damage: float = base_damage
var can_shoot: bool = true
var can_dodge: bool = true
var is_invulnerable: bool = false

@onready var shoot_timer: Timer = Timer.new()
@onready var dodge_timer: Timer = Timer.new()
@onready var invuln_timer: Timer = Timer.new()
@onready var rotation_pivot: Node3D = $RotationPivot
@onready var bullet_spawn: Node3D = $RotationPivot/BulletSpawn
@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var bullet_scene: PackedScene = preload("res://Projectiles/SimpleBullet.tscn")

func _ready() -> void:
	
	# Hook timers
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(dodge_timer)
	dodge_timer.one_shot = true
	dodge_timer.timeout.connect(_on_dodge_timer_timeout)
	add_child(invuln_timer)
	invuln_timer.one_shot = true
	invuln_timer.timeout.connect(_on_invuln_timer_timeout)
	
	# Pull from PlayerData
	update_from_player_data()
	PlayerData.modifiers_updated.connect(update_from_player_data)

func update_from_player_data() -> void:
	# Apply modifiers
	speed = base_speed * PlayerData.modifiers.get("speed_mult", 1.0)
	damage = base_damage * PlayerData.modifiers.get("damage_mult", 1.0)

func _physics_process(_delta: float) -> void:
	# Movement: WASD or arrows, locked to X-Z plane
	var move_input: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	velocity = Vector3(move_input.x, 0, move_input.y) * speed
	move_and_slide()
	
	# Aim: Raycast from camera to X-Z plane (y=0)
	if camera:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
		var ray_dir: Vector3 = camera.project_ray_normal(mouse_pos)
		var plane: Plane = Plane(Vector3(0, 1, 0), 0)
		var aim_point: Variant = plane.intersects_ray(ray_origin, ray_dir)
		if aim_point:
			var look_dir: Vector3 = (aim_point - global_position).normalized()
			rotation_pivot.rotation.y = atan2(look_dir.x, look_dir.z) - PI
	
	# Shoot: Mouse click
	if Input.is_action_pressed("fire_primary") and can_shoot:
		shoot()
	
	# Dodge: Space + direction
	if Input.is_action_just_pressed("dodge") and can_dodge:
		dodge(move_input)

func shoot() -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	get_tree().root.add_child(bullet)
	bullet.global_position = bullet_spawn.global_position
	var angle = rotation_pivot.rotation.y - PI
	var direction = Vector3(sin(angle), 0, cos(angle))
	bullet.linear_velocity = direction * bullet.speed
	bullet.damage = damage
	can_shoot = false
	shoot_timer.start(fire_rate)
	
func dodge(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		var angle = rotation_pivot.rotation.y
		direction = Vector2(-sin(angle), cos(angle))
	var dodge_vector: Vector3 = Vector3(direction.x, 0, direction.y).normalized() * dodge_distance
	velocity += dodge_vector / dodge_cooldown
	is_invulnerable = true
	can_dodge = false
	invuln_timer.start(dodge_invuln_time)
	dodge_timer.start(dodge_cooldown)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_dodge_timer_timeout() -> void:
	can_dodge = true

func _on_invuln_timer_timeout() -> void:
	is_invulnerable = false
