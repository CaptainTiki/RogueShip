extends Node

var current_room_path: String = ""
var current_level: Level = null
var transition_instance: CanvasLayer = null
var room_list: Array[String] = [
	"res://Rooms/TestRoom1.tscn",
    "res://Rooms/TestRoom2.tscn"
]
var run_room_count: int = 0
var max_rooms: int = 3  # Standard -> Standard/Treasure -> Boss

func start_level(room_path: String = "") -> void:
	run_room_count = 1
	if room_path == "":
		current_room_path = room_list[randi() % room_list.size()]
	else:
		current_room_path = room_path
	get_tree().change_scene_to_file("res://Level.tscn")

func go_to_carrier_hub() -> void:
	run_room_count = 0
	get_tree().change_scene_to_file("res://CarrierHub/CarrierHub.tscn")

func next_room(room_path: String) -> void:
	run_room_count += 1
	current_room_path = room_path
	get_tree().change_scene_to_file("res://Level.tscn")
