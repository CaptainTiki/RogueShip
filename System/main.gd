extends Node3D

func _ready() -> void:
	var loadroom: PackedScene = preload("uid://cepnqohmffd6l")
	var room = loadroom.instantiate()
	add_child(room)
	if PlayerData.ship_scene:
		var ship : PlayerShip = PlayerData.ship_scene.instantiate()
		room.add_child(ship)  # Or position it: ship.global_position = Vector2(300, 300)
		ship.global_position = Vector3(0, 0, 0)  # Start at origin
		PlayerData.ship_instance = ship
		room.assign_camera_target(ship)
	else:
		push_error("PlayerData.ship_scene not set!")
