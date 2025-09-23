extends Node
class_name Player_Data

# Core player stats—persistent across scenes
@export var score: int = 0
@export var credits: int = 0  # Your in-game money for upgrades

# Ship reference: We'll store the scene path or instance here
@export var ship_scene: PackedScene = preload("uid://b717h2uu1gkng") #default to our playership scene - leave option to start game with other ships

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


func save_player_data() -> void:
	prints("save_player_data() func empty")
	pass
