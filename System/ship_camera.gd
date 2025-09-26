extends Camera3D
class_name ShipCamera

@export var height: float = 100.0  # Y offset above X-Z plane
@export var ship_smooth_speed: float = 5.0  # Speed for tracking ship
@export var pointer_smooth_speed: float = 3.0  # Speed for tracking mouse pointer
@export var max_pointer_distance: float = 20.0  # Max distance from ship for aim point

var follow_target: Node3D

func _ready() -> void:
	# Look down -Y
	rotation.x = -PI / 2
	if PlayerData.ship_instance:
		follow_target = PlayerData.ship_instance

func _physics_process(delta: float) -> void:
	if follow_target:
		# Get ship position
		var ship_pos = follow_target.global_position
		
		# Get mouse aim point on X-Z plane
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_origin = project_ray_origin(mouse_pos)
		var ray_dir = project_ray_normal(mouse_pos)
		var plane = Plane(Vector3(0, 1, 0), 0)
		var aim_point = plane.intersects_ray(ray_origin, ray_dir)
		
		# Calculate midpoint, clamping aim point distance
		var target_pos = ship_pos
		if aim_point:
			var vector_to_aim = aim_point - ship_pos
			var clamped_aim = ship_pos + vector_to_aim.limit_length(max_pointer_distance)
			target_pos = (ship_pos + clamped_aim) / 2.0
		
		# Lerp to midpoint at camera height, blending ship and pointer speeds
		var new_pos = Vector3(target_pos.x, height, target_pos.z)
		var ship_influence = global_position.lerp(Vector3(ship_pos.x, height, ship_pos.z), ship_smooth_speed * delta)
		var final_pos = ship_influence.lerp(new_pos, pointer_smooth_speed * delta)
		global_position = final_pos

func assign_follow_target(target: Node3D) -> void:
	follow_target = target
