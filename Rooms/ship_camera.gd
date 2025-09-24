extends Camera3D
class_name ShipCamera


@export var height: float = 100.0  # Y offset above X-Z plane
@export var smooth_speed: float = 5.0

var follow_target: Node3D

func _ready() -> void:
	# Look down -Y
	rotation.x = -PI / 2
	if PlayerData.ship_instance:
		follow_target = PlayerData.ship_instance

func _physics_process(delta: float) -> void:
	if follow_target:
		var target_pos = follow_target.global_position
		var new_pos = Vector3(target_pos.x, height, target_pos.z)
		global_position = global_position.lerp(new_pos, smooth_speed * delta)

func assign_follow_target(target: Node3D) -> void:
	follow_target = target
