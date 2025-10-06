extends EnemyBehavior
class_name BoomAndZoomBehavior

func run(enemy: Node, delta: float) -> void:
	if enemy.current_state == "pursue":
		var dir = (enemy.target.global_position - enemy.global_position).normalized()
		enemy.velocity = Vector3(dir.x, 0, dir.z) * enemy.speed * 1.5
	elif enemy.current_state == "attack":
		enemy.velocity = Vector3.ZERO
	if enemy.current_state == "attack" and enemy.attack_timer.time_left == 0 and not enemy.is_staggered:
		enemy._perform_attack()
