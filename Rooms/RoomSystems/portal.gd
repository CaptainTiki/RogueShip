extends Area3D

signal room_selected(room_path: String)

func _ready() -> void:
	disable()

func enable() -> void:
	visible = true
	collision_mask = 1  # Enable collision with player
	monitoring = true

func disable() -> void:
	visible = false
	collision_mask = 0  # Disable collision
	monitoring = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var choices = get_room_choices()
		if choices.size() == 1:
			emit_signal("room_selected", choices[0])
		else:
			show_room_selection_ui(choices)

func get_room_choices() -> Array[String]:
	if GameManager.run_room_count >= GameManager.max_rooms - 1:
		return ["res://Rooms/TestRoom2.tscn"]  # Boss room (placeholder)
	return GameManager.room_list

func show_room_selection_ui(choices: Array[String]) -> void:
	var ui = preload("res://UI/System/RoomSelectionUI.tscn").instantiate()
	get_tree().root.add_child(ui)
	ui.set_room_choices(choices)
	ui.connect("room_selected", func(room_path: String): 
		emit_signal("room_selected", room_path)
		ui.queue_free())
	get_tree().paused = true
