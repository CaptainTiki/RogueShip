class_name OnDestroy
extends Resource

signal destroy_handled  # Signal to indicate handler is done

# Base method to handle enemy destruction
func handle_destroy(enemy: Enemy) -> void:
	var scrap_amount = randi_range(1, 5)
	
	# Elite: chance for module drop (pick 1 of 3)
	if enemy.is_elite and randf() < 0.75:
		scrap_amount = scrap_amount * 1.25
		var boon_ui_scene = preload("res://UI/System/BoonPickerUI.tscn")
		var boon_ui = boon_ui_scene.instantiate()
		print(boon_ui.get_class())
		if boon_ui is BoonPickerUI:
			boon_ui.modules = [
				ModManager.get_random_unlocked_mod(),
				ModManager.get_random_unlocked_mod(),
				ModManager.get_random_unlocked_mod()
			]
			enemy.get_tree().root.add_child(boon_ui)
			boon_ui.global_position = enemy.global_position

	# Mini-Boss: Guaranteed large scrap + boon (3 module choices)
	if enemy.is_mini_boss:
		scrap_amount = scrap_amount * 2
		var boon_ui = preload("res://UI/System/BoonPickerUI.tscn").instantiate() as BoonPickerUI
		boon_ui.modules = [
			ModManager.get_random_unlocked_mod(),
			ModManager.get_random_unlocked_mod(),
			ModManager.get_random_unlocked_mod()
		]
		enemy.get_tree().root.add_child(boon_ui)
		boon_ui.global_position = enemy.global_position
	

	## Spawn scrap (all enemies)
	#var scrap_pickup = preload("res://ScrapPickup.tscn").instantiate() as ScrapPickup
	#if scrap_pickup is ScrapPickup:
		#scrap_pickup.amount = scrap_amount
		#enemy.get_tree().root.add_child(scrap_pickup)
		#scrap_pickup.global_position = Vector3(
			#enemy.global_position.x + randf_range(-2, 2), 
			#enemy.global_position.y, 
			#enemy.global_position.z + randf_range(-2, 2))
	
	destroy_handled.emit()
