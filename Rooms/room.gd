extends Node3D
class_name Room

signal room_cleared

enum RoomType {
	STANDARD,
	WAVE,
	TREASURE,
	PUZZLE,
	BOSS
}

@export_category("Room Type")
@export var room_type: RoomType = RoomType.STANDARD
@export_category("Room Size")
@export var room_min_x: float = -50.0
@export var room_max_x: float = 50.0
@export var room_min_z: float = -100.0
@export var room_max_z: float = 100.0

@onready var portal: Area3D = $Systems/Portal

var enemies_remaining: int = 0

func _ready() -> void:
	reset_room()

func reset_room() -> void:
	portal.disable()

func enemy_killed() -> void:
	pass

func spawn_portal() -> void:
	portal.enable()

func _on_portal_room_selected(room_path: String) -> void:
	var level = get_tree().current_scene as Level
	if level:
		level.next_room(room_path)

func get_room_bounds() -> Dictionary:
	return {
		"min_x": room_min_x,
		"max_x": room_max_x,
		"min_z": room_min_z,
		"max_z": room_max_z
	}
