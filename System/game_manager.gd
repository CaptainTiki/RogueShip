extends Node

var current_room_path: String = ""
var current_level: Level = null
var transition_instance: CanvasLayer = null
var room_list: Array[String] = [
	"res://Rooms/StandardRoomTest.tscn",
	"res://Rooms/WaveRoomTest.tscn",
	"res://Rooms/TreasureRoomTest.tscn",
	"res://Rooms/BossRoomTest.tscn",
	"res://Rooms/PuzzleRoomTest.tscn"
]
var run_room_count: int = 0
var max_rooms: int = 3 #includes final room (boss room)

var standard_rooms: Array[String] = ["res://Rooms/StandardRoomTest.tscn"]
var wave_rooms: Array[String] = ["res://Rooms/WaveRoomTest.tscn"]
var treasure_rooms: Array[String] = ["res://Rooms/TreasureRoomTest.tscn"]
var puzzle_rooms: Array[String] = ["res://Rooms/PuzzleRoomTest.tscn"]
var boss_rooms: Array[String] = ["res://Rooms/BossRoomTest.tscn"] 
	
func start_level(room_path: String = "") -> void:
	run_room_count = 1
	if DebugRuntime.room_override != "":
		current_room_path = DebugRuntime.room_override
		DebugRuntime.room_override = ""  # Reset for next time
	elif room_path == "":
		current_room_path = standard_rooms[randi() % standard_rooms.size()]
	else:
		current_room_path = room_path
	get_tree().change_scene_to_file("res://Level.tscn")

func go_to_carrier_hub() -> void:
	run_room_count = 0
	get_tree().change_scene_to_file("res://CarrierHub/CarrierHub.tscn")

func get_random_room_for_type(type: int) -> String:
	match type:
		Room.RoomType.STANDARD:
			return standard_rooms[randi() % standard_rooms.size()]
		Room.RoomType.WAVE:
			return wave_rooms[randi() % wave_rooms.size()]
		Room.RoomType.TREASURE:
			return treasure_rooms[randi() % treasure_rooms.size()]
		Room.RoomType.BOSS:
			return boss_rooms[randi() % boss_rooms.size()]
	return ""  # fallback, log error if hit
	
func next_room(room_path: String) -> void:
	run_room_count += 1
	current_room_path = room_path
	current_level.next_room(current_room_path)
