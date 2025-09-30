extends Room
class_name BossRoom

@export var boss_scene: Node3D

func _ready() -> void:
	reset_room()

func reset_room() -> void:
	portal.disable()
	enemies_remaining = 0
	var objects = get_node_or_null("Objects")
	if objects:
		for child in objects.get_children():
			if child.is_in_group("scrap") or child.is_in_group("boon"):
				child.queue_free()
		var enemies = objects.get_node_or_null("Enemies")
		if enemies:
			var boss = get_boss_node(enemies)
			if boss and boss.has_signal("died"):
				boss.died.connect(_on_boss_killed)
			for enemy in enemies.get_children():
				if enemy != boss:
					enemies_remaining += 1
					if enemy.has_signal("died"):
						enemy.died.connect(enemy_killed)

func enemy_killed() -> void:
	enemies_remaining -= 1

func _on_boss_killed() -> void:
	clear_remaining_enemies()
	emit_signal("room_cleared")
	spawn_portal()

func get_boss_node(enemies: Node) -> Node:
	if enemies:
		for child in enemies.get_children():
			if boss_scene and child.scene_file_path == boss_scene.resource_path:
				return child
			if child.is_in_group("boss"):  # Fallback to boss group
				return child
	return null

func clear_remaining_enemies() -> void:
	var objects = get_node_or_null("Objects")
	if objects:
		var enemies = objects.get_node_or_null("Enemies")
		if enemies:
			for enemy in enemies.get_children():
				if enemy.has_method("die_unscored"):
					enemy.die_unscored()
				elif enemy.has_method("destroy"):
					enemy.destroy()
		var hazards = objects.get_node_or_null("Hazards")
		if hazards:
			for hazard in hazards.get_children():
				if hazard.is_in_group("spawner") and hazard.has_method("destroy"):
					hazard.destroy()
