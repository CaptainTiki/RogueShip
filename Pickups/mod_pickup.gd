extends Area3D
class_name ModPickup

signal picked_up

var mod: Mod
var velocity: Vector3 = Vector3.ZERO
var max_speed: float = 10
var friction: float = 0.95

func _ready() -> void:
	mod = ModManager.get_random_unlocked_mod()
	# Random direction (x/z only) and speed
	var direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	velocity = direction * randf_range(2, max_speed)  # Initial burst, 2-5 units/sec

func _physics_process(delta: float) -> void:
	if velocity.length() > 0.1:  # Stop processing when nearly still
		global_position += velocity * delta
		velocity *= friction
	else:
		velocity = Vector3.ZERO
		set_physics_process(false)  # Optimize: turn off once stopped

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerShip and body.ship_mod_manager:
		body.ship_mod_manager.add_mod(mod)
		body.ship_mod_manager.update_stats(body)
		print("pickup mod: ", mod.name)
		picked_up.emit()
		queue_free()
