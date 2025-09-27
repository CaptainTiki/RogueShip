extends EnemyBehavior
class_name CircleAndSnipeBehavior

func run(enemy: Node, delta: float) -> void:
	var dir = (enemy.target.global_position - enemy.global_position).normalized()
	var orbit_dir = dir.rotated(Vector3.UP, PI/2)
	enemy.velocity = (dir * 0.5 + orbit_dir) * enemy.speed
	if enemy.current_state == "attack" and enemy.attack_timer.time_left == 0 and not enemy.is_staggered:
		enemy._perform_attack()
