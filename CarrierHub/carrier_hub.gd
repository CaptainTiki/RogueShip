extends Node2D
class_name CarrierHub

func _ready() -> void:
	pass

func _on_launch_pressed() -> void:
	# For now, always load TestRoom.tscn
	GameManager.start_level("res://Rooms/TestRoom.tscn")
