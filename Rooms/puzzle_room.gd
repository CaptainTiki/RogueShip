extends Room
class_name PuzzleRoom

func _ready() -> void:
	reset_room()

func reset_room() -> void:
	enemies_remaining = 0
	var objects = get_node_or_null("Objects")
	if objects:
		for child in objects.get_children():
			if child.is_in_group("scrap") or child.is_in_group("boon"):
				child.queue_free()
		var enemies = objects.get_node_or_null("Enemies")
		if enemies:
			for enemy in enemies.get_children():
				enemies_remaining += 1
				if enemy.has_signal("died"):
					enemy.died.connect(enemy_killed)
	spawn_portal()  # Portal starts enabled

func enemy_killed() -> void:
	enemies_remaining -= 1
