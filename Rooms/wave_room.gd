extends Room
class_name WaveRoom

var spawners: Array[Node] = []
var active_spawners: int = 0

func _ready() -> void:
	reset_room()

func reset_room() -> void:
	portal.disable()
	enemies_remaining = 0
	spawners.clear()
	active_spawners = 0

	var objects = get_node_or_null("Objects")
	if objects:
		for child in objects.get_children():
			if child.is_in_group("scrap") or child.is_in_group("boon"):
				child.queue_free()
		var hazards = objects.get_node_or_null("Hazards")
		if hazards:
			for hazard in hazards.get_children():
				if hazard.is_in_group("spawner"):
					spawners.append(hazard)
					active_spawners += 1
					if hazard.has_signal("spawner_empty"):
						hazard.spawner_empty.connect(_on_spawner_empty)
					for enemy in hazard.get_children():
						if enemy.is_in_group("enemy"):
							enemies_remaining += 1
							if enemy.has_signal("died"):
								enemy.died.connect(enemy_killed)

func enemy_killed() -> void:
	enemies_remaining -= 1
	check_room_cleared()

func _on_spawner_empty() -> void:
	active_spawners -= 1
	check_room_cleared()

func check_room_cleared() -> void:
	if active_spawners <= 0 and enemies_remaining <= 0:
		emit_signal("room_cleared")
		spawn_portal()
