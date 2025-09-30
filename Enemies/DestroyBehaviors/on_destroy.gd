class_name OnDestroy
extends Resource

signal destroy_handled  # Signal to indicate handler is done

# Base method to handle enemy destruction
func handle_destroy(enemy: Enemy) -> void:
	var scrap_amount = randi_range(1, 5)
	
	# Elite: chance for boon drop
	if enemy.is_elite and randf() < 0.75:
		scrap_amount = scrap_amount * 1.25
		var boon_pickup_scene = preload("res://Pickups/BoonPickup.tscn")
		var boon_pickup = boon_pickup_scene.instantiate() as BoonPickup
		GameManager.current_level.current_room.add_child(boon_pickup)
		boon_pickup.global_position = enemy.global_position

	# Mini-Boss: Guaranteed boon
	if enemy.is_mini_boss:
		scrap_amount = scrap_amount * 2
		var boon_pickup_scene = preload("res://Pickups/BoonPickup.tscn")
		var boon_pickup = boon_pickup_scene.instantiate() as BoonPickup
		GameManager.current_level.current_room.add_child(boon_pickup)
		boon_pickup.global_position = enemy.global_position
	
	# Spawn scrap (all enemies)
	for num in scrap_amount:
		var scrap_pickup = preload("res://Pickups/ScrapPickup.tscn").instantiate() as ScrapPickup
		GameManager.current_level.current_room.add_child(scrap_pickup)
		scrap_pickup.global_position = Vector3(
			enemy.global_position.x + randf_range(-2, 2), 
			enemy.global_position.y, 
			enemy.global_position.z + randf_range(-2, 2))
	
	destroy_handled.emit()
