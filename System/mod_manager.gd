extends Node
class_name Mod_Manager

# Future: Store all available mods (e.g., from disk or predefined)
var mod_pool: Array[Mod] = [
	preload("res://Mods/SprayNPrayMod.tres"),
	preload("res://Mods/Splits.tres")
]

# Stub for random mod selection
func get_random_unlocked_mod() -> Mod:
	return mod_pool[randi() % mod_pool.size()]
