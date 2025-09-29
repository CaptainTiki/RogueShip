extends CanvasLayer

signal room_selected(room_path: String)

@onready var vbox: VBoxContainer = $VBoxContainer

func set_room_choices(choices: Array[String]) -> void:
	for choice in choices:
		var button = Button.new()
		button.text = choice.get_file().get_basename()  # e.g., "TestRoom1"
		button.pressed.connect(func(): 
			emit_signal("room_selected", choice)
			get_tree().paused = false)
		vbox.add_child(button)
