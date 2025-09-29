extends Node3D
class_name Room

signal room_cleared

@onready var portal: Area3D = $Systems/Portal

var enemies_remaining: int = 0
var room_min_x: float = -50.0
var room_max_x: float = 50.0
var room_min_z: float = -100.0
var room_max_z: float = 100.0

func _ready() -> void:
	portal.disable()

func enemy_killed() -> void:
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		emit_signal("room_cleared")
		spawn_portal()

func spawn_portal() -> void:
	portal.enable()
	portal.connect("room_selected", _on_portal_room_selected)

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
