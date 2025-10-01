class_name OnDestroy
extends Resource

signal destroy_handled

func handle_destroy(enemy: Enemy) -> void:
	var scrap_amount = randi_range(1, 5)
	
	# Elite: chance for boon drop
	if enemy.is_elite and randf() < 0.75:
		scrap_amount = int(scrap_amount * 1.25)  # Fixed to int for cleaner counts
		var mod_pickup_scene = preload("res://Pickups/ModPickup.tscn")
		var mod_pickup = mod_pickup_scene.instantiate() as ModPickup
		GameManager.current_level.current_room.add_child(mod_pickup)
		mod_pickup.global_position = enemy.global_position

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
		scrap_pickup.global_position = enemy.global_position
	
	destroy_handled.emit()
