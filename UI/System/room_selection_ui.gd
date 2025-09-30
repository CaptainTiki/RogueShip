extends CanvasLayer

signal room_selected(room_path: String)

@onready var vbox: VBoxContainer = $VBoxContainer

func set_room_choices(choices: Array[String]) -> void:
	for choice in choices:
		var button = Button.new()
		button.text = choice  # e.g., "Wave"
		button.pressed.connect(func():
			var type_int: int = _string_to_type(choice)  # helper below
			var room_path = GameManager.get_random_room_for_type(type_int)
			GameManager.next_room(room_path)
			emit_signal("room_selected", room_path)
			get_tree().paused = false
		)
		vbox.add_child(button)

func _string_to_type(type_str: String) -> int:
	match type_str.to_upper():
		"STANDARD": return Room.RoomType.STANDARD
		"WAVE": return Room.RoomType.WAVE
		"TREASURE": return Room.RoomType.TREASURE
		"BOSS": return Room.RoomType.BOSS
	return -1  # error
