extends RigidBody3D
class_name Bullet

@export var speed: float = 25.0  # Pixels/sec
@export var damage: float = 10.0  # Base damage
@export var pierce_count: int = 0  # Hits before destroy
@export var bounce_enabled: bool = false  # Bounce on collision
var current_pierce: int = 0

@onready var lifetime: Timer = $LifeTime

func _ready() -> void:
	# Start lifetime timer
	lifetime.timeout.connect(queue_free)
	lifetime.start()
	
	# Apply PlayerData modifiers
	damage *= PlayerData.modifiers.get("damage_mult", 1.0)
	current_pierce = PlayerData.modifiers.get("pierce_count", 0)
	if PlayerData.modifiers.get("bounce_enabled", false):
		bounce_enabled = true
		physics_material_override = PhysicsMaterial.new()
		physics_material_override.bounce = 0.8

func _physics_process(_delta: float) -> void:
	# Constant velocity forward (set in ship)
	pass

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		current_pierce -= 1
		if current_pierce < 0 and not bounce_enabled:
			queue_free()
	elif body.is_in_group("enemies"):
		body.take_damage(damage)
		current_pierce -= 1
		if current_pierce < 0 and not bounce_enabled:
			queue_free()
	elif body.is_in_group("terrain") and not bounce_enabled:
		print("terrain")
		queue_free()
