extends Area3D
class_name ExitPortal

@export var enabled: bool = false

func _ready() -> void:
	# Disable collisions until enabled
	monitoring = enabled
	collision_layer = 1  # Player
	collision_mask = 1   # Player

func disable() -> void:
	enabled = false
	monitoring = false
	visible = false

func enable() -> void:
	enabled = true
	monitoring = true
	visible = true

func _on_body_entered(body: Node3D) -> void:
	if enabled and body.is_in_group("player"):
		# Signal room clear from Room
		get_parent().get_parent().emit_signal("room_cleared")
