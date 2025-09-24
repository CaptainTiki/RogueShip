extends Node3D
class_name Room

signal room_cleared

@onready var exit_portal: ExitPortal = $Systems/ExitPortal

var enemies_remaining: int = 0

func _ready() -> void:
	# Count spawners' enemies
	var spawners = get_tree().get_nodes_in_group("spawners")
	for spawner in spawners:
		if spawner is EnemySpawner:
			enemies_remaining += spawner.max_spawns
	exit_portal.disable()


func enemy_killed() -> void:
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		exit_portal.enable()
