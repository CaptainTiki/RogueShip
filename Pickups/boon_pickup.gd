extends Area3D
class_name BoonPickup

signal picked_up

var velocity: Vector3 = Vector3.ZERO
var max_speed: float = 10
var friction: float = 0.95

func _ready() -> void:
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
	if body is PlayerShip:
		var boon_ui_scene = preload("res://UI/System/BoonPickerUI.tscn")
		var boon_ui = boon_ui_scene.instantiate() as BoonPickerUI
		get_tree().root.add_child(boon_ui)
		get_tree().paused = true  # Pause the game
		picked_up.emit()
		queue_free()  # Remove the pickup
