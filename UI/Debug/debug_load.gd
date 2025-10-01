extends CanvasLayer

@onready var popup: Popup = $Popup
@onready var tab_container: TabContainer = $Popup/VBoxContainer/TabContainer
@onready var standard_list: ItemList = $Popup/VBoxContainer/TabContainer/Standard
@onready var wave_list: ItemList = $Popup/VBoxContainer/TabContainer/Wave
@onready var treasure_list: ItemList = $Popup/VBoxContainer/TabContainer/Treasure
@onready var puzzle_list: ItemList = $Popup/VBoxContainer/TabContainer/Puzzle
@onready var boss_list: ItemList = $Popup/VBoxContainer/TabContainer/Boss

var selected_room: String = ""

func _ready() -> void:
	popup.popup_centered()
	populate_rooms()

func populate_rooms() -> void:
	# Clear all lists
	standard_list.clear()
	wave_list.clear()
	treasure_list.clear()
	puzzle_list.clear()
	boss_list.clear()

	# Populate each list with corresponding rooms
	for room in GameManager.standard_rooms:
		standard_list.add_item(room.get_file())
		standard_list.set_item_metadata(standard_list.item_count - 1, room)
	
	for room in GameManager.wave_rooms:
		wave_list.add_item(room.get_file())
		wave_list.set_item_metadata(wave_list.item_count - 1, room)
	
	for room in GameManager.treasure_rooms:
		treasure_list.add_item(room.get_file())
		treasure_list.set_item_metadata(treasure_list.item_count - 1, room)
	
	for room in GameManager.puzzle_rooms:
		puzzle_list.add_item(room.get_file())
		puzzle_list.set_item_metadata(puzzle_list.item_count - 1, room)
	
	for room in GameManager.boss_rooms:
		boss_list.add_item(room.get_file())
		boss_list.set_item_metadata(boss_list.item_count - 1, room)

func _on_room_list_item_selected(index: int) -> void:
	var sender: ItemList = tab_container.get_current_tab_control() as ItemList
	if sender and sender.is_anything_selected():
		selected_room = sender.get_item_metadata(index)
		print("Selected room: ", selected_room)  # Debug to confirm selection
	else:
		print("Error: No valid ItemList or no item selected")

func _on_launch_pressed() -> void:
	if selected_room != "":
		DebugRuntime.room_override = selected_room
		get_parent()._on_launch_pressed()
	popup.hide()
	queue_free()

func _on_cancel_pressed() -> void:
	popup.hide()
	queue_free()
