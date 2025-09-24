extends Node
class_name Player_Data

# Core player stats—persistent across scenes
@export var score: int = 0
@export var credits: int = 0  # Your in-game money for upgrades

# Ship reference: We'll store the scene path or instance here
@export var ship_scene: PackedScene = preload("res://Ship/PlayerShip.tscn") #default to our playership scene - leave option to start game with other ships

# Modifiers: Dictionary for boons/curses—easy to expand
@export var modifiers: Dictionary = {
	"damage_mult": 1.0,
	"pierce_count": 0,
	"bounce_enabled": false,
	"health_mult": 1.0  # For tankier runs
}

# Boons/curses array—strings or enums for now, e.g., ["double_damage", "low_grav"]
@export var active_boons: Array[String] = []
@export var active_curses: Array[String] = []

# Signals for when stuff changes—hook these up in other scripts
signal score_changed(new_score: int)
signal modifiers_updated()


var ship_instance : PlayerShip

func _ready() -> void:
	# Skip early load; use get_ship instead
	pass

func get_ship() -> PlayerShip:
	if ship_instance == null:
		if ship_scene:
			ship_instance = ship_scene.instantiate() as PlayerShip
			if ship_instance == null:
				push_error("Ship instantiate failed from " + ship_scene.resource_path)
		else:
			push_error("No ship_scene set in Player_Data")
	return ship_instance

func save_player_data() -> void:
	# Stub: Dump to console/file later
	print("Saving data: score=", score, " credits=", credits, " mods=", modifiers)
	# TODO: ResourceSaver.save to user://save.res
