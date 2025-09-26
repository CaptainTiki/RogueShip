extends Node
class_name Weapon


@export var base_stat : WeaponStats
var wstat : WeaponStats

@onready var muzzle: Marker3D = $Muzzle
@onready var fire_timer: Timer = Timer.new()

var can_fire: bool = true

func initialize():
	wstat = WeaponStats.new()
	add_child(fire_timer)
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)

func shoot(ship_rotation_y: float):
	if not can_fire or not muzzle:
		return
	# Base direction (muzzle's forward, -Z)
	var base_direction = -muzzle.global_transform.basis.z.normalized()
	var total_shots = 1 + wstat.split_count
	
	for i in range(total_shots):
		var direction = base_direction
		if total_shots > 1:
			# Spread shots evenly around Y-axis
			var angle = deg_to_rad(wstat.spread_angle) * (i - (total_shots - 1) / 2.0)
			direction = base_direction.rotated(Vector3.UP, angle)
		
		var bullet = wstat.projo_scene.instantiate() as Bullet
		get_tree().root.add_child(bullet)
		bullet.global_position = muzzle.global_position
		bullet.linear_velocity = direction * bullet.speed
		bullet.damage = wstat.damage
		# Apply effects later: e.g., chain, explode
	can_fire = false
	fire_timer.start(wstat.fire_rate)

func _on_fire_timer_timeout():
	can_fire = true
