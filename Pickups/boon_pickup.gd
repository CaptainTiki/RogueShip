extends Area3D
class_name BoonPickup

signal picked_up

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerShip:
		var boon_ui_scene = preload("res://UI/System/BoonPickerUI.tscn")
		var boon_ui = boon_ui_scene.instantiate() as BoonPickerUI
		get_tree().root.add_child(boon_ui)
		get_tree().paused = true  # Pause the game
		picked_up.emit()
		queue_free()  # Remove the pickup
