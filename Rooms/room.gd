extends Node3D
class_name Room

@onready var camera_3d: ShipCamera = $Environment/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func assign_camera_target(target: Node3D) -> void:
	camera_3d.follow_target = target
	pass
