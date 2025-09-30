extends CanvasLayer
class_name BoonPickerUI

var modules: Array[Mod] = []  # Array of Mod resources from Mod_Manager

func _ready() -> void:
	get_tree().paused = true
	# Generate 3 random mods if not pre-set (for proto flexibility)
	if modules.is_empty():
		for i in 3:
			modules.append(ModManager.get_random_unlocked_mod())
	# Update buttons
	for i in range(min(modules.size(), 3)):
		var button = get_node("Panel/VBoxContainer/ModuleButton" + str(i + 1))
		var mod = modules[i]
		var buff_text = _format_buff(mod)
		var curse_text = _format_curse(mod)
		button.text = "%s\nBuff: %s\nCurse: %s" % [mod.name, buff_text, curse_text]

func _format_buff(mod: Mod) -> String:
	var buffs = []
	if mod.damage_mult != 1.0: buffs.append("Damage x%.2f" % mod.damage_mult)
	if mod.split_count > 0: buffs.append("Splits into %d shots (%d° spread)" % [mod.split_count + 1, mod.spread_angle])  # +1 for original
	if mod.fire_rate_mult != 1.0: buffs.append("Fire rate x%.2f" % mod.fire_rate_mult)
	# Add more if-checks for other props as you expand
	return ", ".join(buffs) if !buffs.is_empty() else "No buff"

func _format_curse(mod: Mod) -> String:
	var curses = []
	if mod.damage_mult < 1.0: curses.append("Damage penalty (x%.2f)" % mod.damage_mult)  # Treat <1 as curse for now
	# Expand similarly for other negative props
	return ", ".join(curses) if !curses.is_empty() else "No curse"

func _on_module_button_pressed(index: int) -> void:
	if index < modules.size():
		var mod = modules[index]
		var ship : PlayerShip = PlayerData.get_ship()  # Grabs or instantiates the ship
		ship.ship_mod_manager.add_mod(mod)     # Adds the Mod resource to mods array
		ship.ship_mod_manager.update_stats(ship)  # Resets to base, applies all mods
		
		# Optional: Track in PlayerData for save/UI later
		#TODO: Notify playerdata that we have a mod, so it can mark it as found
		PlayerData.active_boons.append(mod.name)
		PlayerData.modifiers_updated.emit()  # If you want to keep this signal for future UI
		
	get_tree().paused = false
	queue_free()
