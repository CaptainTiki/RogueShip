extends Node3D
class_name Level

@onready var ship_camera: ShipCamera = $ShipCamera
var current_room: Room = null

func _ready() -> void:
	var ship = PlayerData.get_ship()
	if ship:
		add_child(ship)
		ship.global_position = Vector3(0, 0, 0)
		PlayerData.ship_instance = ship
		if ship_camera:
			ship_camera.assign_follow_target(ship)
	else:
		push_error("Failed to get ship in Level")
	load_room(GameManager.current_room_path)
	GameManager.current_level = self

func load_room(room_path: String) -> void:
	var room_scene = load(room_path)
	if room_scene:
		current_room = room_scene.instantiate()
		add_child(current_room)
		current_room.connect("room_cleared", _on_room_cleared)

func _on_room_cleared() -> void:
	# Stash any run data
	PlayerData.save_player_data()  # Hook for score/credits save
	# Return to carrier hub
	GameManager.go_to_carrier_hub()

func enemy_killed() -> void: #helps track enemies through to the current_room
	current_room.enemy_killed()
	pass
