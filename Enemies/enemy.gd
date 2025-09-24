extends CharacterBody3D
class_name Enemy

@export var speed: float = 10.0  # Pixels/sec
@export var health: float = 20.0  # Takes 2 default bullets

func _physics_process(_delta: float) -> void:
	# Chase player
	if PlayerData.ship_instance:
		var direction = (PlayerData.ship_instance.global_position - global_position).normalized()
		velocity = Vector3(direction.x, 0, direction.z) * speed
		move_and_slide()

func _on_hit_box_area_entered(area: Area3D) -> void:
	if area.owner.is_in_group("bullets"):
		var bullet: Bullet = area.owner as Bullet
		if bullet:
			health -= bullet.damage
			print(health)
			if health <= 0:
				PlayerData.credits += 10  # Or score += 50
				get_parent().enemy_killed()
				queue_free()
