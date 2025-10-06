extends PatternBehavior
class_name SineWavePattern

@export var amplitude: float = 2.0
@export var frequency: float = 5.0

func run(enemy: PatternEnemy, delta: float) -> void:
	enemy.time += delta
	var offset = sin(enemy.time * frequency) * amplitude
	enemy.velocity = Vector3(offset, 0, enemy.speed)  # Move down, weave left/right
