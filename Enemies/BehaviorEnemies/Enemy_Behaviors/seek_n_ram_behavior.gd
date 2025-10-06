extends EnemyBehavior
class_name SeekAndRamBehavior

func run(enemy: Node, delta: float) -> void:
	var dir = (enemy.target.global_position - enemy.global_position).normalized()
	enemy.velocity = Vector3(dir.x, 0, dir.z) * enemy.speed
	if enemy.current_state == "pursue":
		enemy.velocity *= 1.5
	if enemy.current_state == "attack" and enemy.attack_timer.time_left == 0 and not enemy.is_staggered:
		enemy._perform_attack()
