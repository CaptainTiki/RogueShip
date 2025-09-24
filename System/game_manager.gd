extends Node
class_name Game_Manager

@export var carrier_hub_scene: PackedScene = preload("res://CarrierHub/CarrierHub.tscn")
@export var level_scene: PackedScene = preload("res://Level.tscn")
var current_room_path: String = "res://scenes/TestRoom.tscn" #default room
var current_level: Level

func _ready() -> void:
	# Start in carrier hub
	go_to_carrier_hub()

func go_to_carrier_hub() -> void:
	get_tree().change_scene_to_packed(carrier_hub_scene)

func start_level(room_path: String = current_room_path) -> void:
	current_room_path = room_path
	get_tree().change_scene_to_packed(level_scene)
