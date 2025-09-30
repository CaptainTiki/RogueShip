extends Room
class_name TreasureRoom

@export var treasure_scene: Node3D

func _ready() -> void:
	reset_room()

func reset_room() -> void:
	portal.disable()
	enemies_remaining = 0
	var objects = get_node_or_null("Objects")
	if objects:
		for child in objects.get_children():
			if child.is_in_group("scrap") or (child.is_in_group("boon") and child != get_treasure_node()):
				child.queue_free()
		var enemies = objects.get_node_or_null("Enemies")
		if enemies:
			for enemy in enemies.get_children():
				enemies_remaining += 1
				if enemy.has_signal("died"):
					enemy.died.connect(enemy_killed)
		var treasure = get_treasure_node()
		if treasure and treasure.has_signal("picked_up"):
			treasure.picked_up.connect(_on_treasure_picked_up)

func enemy_killed() -> void:
	enemies_remaining -= 1

func _on_treasure_picked_up() -> void:
	print("spawning portal")
	emit_signal("room_cleared")
	spawn_portal()

func get_treasure_node() -> Node:
	var objects = get_node_or_null("Objects")
	if objects:
		for child in objects.get_children():
			if child.is_in_group("boon") and (not treasure_scene or child.scene_file_path == treasure_scene.resource_path):
				return child
	return null
