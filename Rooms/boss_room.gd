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
			if boss_scene and boss_scene.has_signal("destroyed"):
				boss_scene.destroyed.connect(_on_boss_killed)
			for enemy in enemies.get_children():
				if enemy != boss_scene:
					enemies_remaining += 1
					if enemy.has_signal("destroyed"):
						enemy.destroyed.connect(enemy_killed)

func enemy_killed() -> void:
	enemies_remaining -= 1

func _on_boss_killed() -> void:
	print("boss killed")
	emit_signal("room_cleared")
	spawn_portal()
