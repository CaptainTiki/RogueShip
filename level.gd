extends Node3D
class_name Level

@onready var ship_camera: ShipCamera = $ShipCamera
@onready var playspace: Area3D = $PlaySpace
@onready var activation_area: Area3D = $PlaySpace/ActivationArea
@onready var destruction_area: Area3D = $PlaySpace/DestructionArea
var current_room: Room = null
var playspace_stop_location : float = 0
@export var scroll_speed: float = 3.0

func _ready() -> void:
	GameManager.current_level = self
	var ship = PlayerData.get_ship()
	if ship:
		add_child(ship)
		PlayerData.ship_instance = ship
		if ship_camera:
			ship_camera.assign_follow_target(ship)
	else:
		push_error("Failed to get ship in Level")
	load_room(GameManager.current_room_path)
	setup_positions()
	
	if GameManager.transition_instance:
		GameManager.transition_instance.fade_in()
		GameManager.transition_instance = null

func setup_positions() -> void:
	if playspace and current_room:
		var room_bounds = current_room.get_room_bounds()
		if current_room.room_type in [Room.RoomType.STANDARD, Room.RoomType.PUZZLE]:
			PlayerData.ship_instance.global_position = Vector3(0, 0, room_bounds.max_z - 5)
			playspace.global_position.z = room_bounds.max_z - 25
			var play_bounds = get_play_bounds()
			playspace_stop_location = room_bounds.min_z - play_bounds.center_z + play_bounds.max_z
		else:  # WAVE, TREASURE, BOSS - center everything
			var mid_z = (room_bounds.min_z + room_bounds.max_z) / 2.0
			PlayerData.ship_instance.global_position = Vector3(0, 0, mid_z)
			playspace.global_position.z = mid_z

func _physics_process(delta: float) -> void:
	if current_room and current_room.room_type in [Room.RoomType.STANDARD, Room.RoomType.PUZZLE]:
		if playspace and playspace.global_position.z >= playspace_stop_location:
			playspace.global_position.z -= scroll_speed * delta

func get_play_bounds() -> Dictionary:
	if playspace:
		var shape = playspace.get_node("CollisionShape3D").shape
		if shape is BoxShape3D:
			var extents = shape.size / 2.0
			var center = playspace.global_position
			return {
				"min_x": center.x - extents.x,
				"max_x": center.x + extents.x,
				"min_z": center.z - extents.z,
				"max_z": center.z + extents.z,
				"center_z": center.z
			}
	return {}

func load_room(room_path: String) -> void:
	var room_scene = load(room_path)
	if room_scene:
		current_room = room_scene.instantiate()
		add_child(current_room)
		current_room.connect("room_cleared", _on_room_cleared)

func next_room(room_path: String) -> void:
	var transition = preload("res://UI/Menus/TransitionScene.tscn").instantiate()
	get_tree().root.add_child(transition)
	transition.fade_out()
	await transition.transition_complete
	if current_room:
		current_room.queue_free()
		await current_room.tree_exited
	load_room(room_path)
	setup_positions()
	if current_room:
		var room_bounds = current_room.get_room_bounds()
		PlayerData.ship_instance.global_position = Vector3(0, 0, room_bounds.max_z - 5)
		playspace.global_position.z = room_bounds.max_z - 25
	transition.fade_in()

func _on_room_cleared() -> void:
	if GameManager.run_room_count >= GameManager.max_rooms:
		PlayerData.save_player_data()
		GameManager.go_to_carrier_hub()
	# Else, portal handles next room via signal

func player_death() -> void:
	GameManager.go_to_carrier_hub()

func enemy_killed() -> void:
	current_room.enemy_killed()

func _on_activation_body_entered(body: Node) -> void:
	if body.has_method("activate"):
		body.activate()

func _on_activation_area_entered(area: Area3D) -> void:
	if area.has_method("activate"):
		area.activate()

func _on_destruction_body_entered(body: Node) -> void:
	if body.has_method("die_unscored"):
		body.die_unscored()
	elif body.has_method("destroy"):
		body.destroy()

func _on_destruction_area_entered(area: Area3D) -> void:
	if area.has_method("destroy"):
		area.destroy()
