extends Room
class_name TreasureRoom

@export var main_treasure: Node3D  # Drag your central BoonPickup here in the editor

func _ready() -> void:
	reset_room()

func reset_room() -> void:
	portal.disable()
	enemies_remaining = 0
	var objects = get_node_or_null("Objects")
	if objects:
		for child in objects.get_children():
			if (child.is_in_group("scrap") or child.is_in_group("boon")) and child != main_treasure:
				child.queue_free()
		var enemies = objects.get_node_or_null("Enemies")
		if enemies:
			for enemy in enemies.get_children():
				enemies_remaining += 1
				if enemy.has_signal("died"):
					enemy.died.connect(enemy_killed)
	if main_treasure and main_treasure.has_signal("picked_up"):
		main_treasure.picked_up.connect(_on_treasure_picked_up)

func enemy_killed() -> void:
	enemies_remaining -= 1
	# Optional: want enemies to gate the portal too, add check_room_cleared() here

func _on_treasure_picked_up() -> void:
	print("Treasure picked up - spawning portal")
	emit_signal("room_cleared")
	spawn_portal()
