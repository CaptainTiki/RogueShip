extends Node
class_name ShipModManager

var mods: Array[Mod] = []

func add_mod(new_mod: Mod) -> void:
	mods.append(new_mod)
	print("Applied mod: ", new_mod.name)

func update_stats(ship: PlayerShip) -> void:
	if not ship or not ship.stats or not ship.base_stats:
		return
	# Reset ship and weapon stats to base
	_reset_to_base_stats(ship)
	# Apply mods to ship stats
	_apply_ship_mods(ship)
	# Apply mods to weapons
	_apply_weapon_mods(ship)

func _reset_to_base_stats(ship: PlayerShip) -> void:
	# Reset ship stats to base
	ship.stats.top_speed = ship.base_stats.top_speed
	ship.stats.acceleration = ship.base_stats.acceleration
	ship.stats.turn_rate = ship.base_stats.turn_rate
	ship.stats.boost_speed = ship.base_stats.boost_speed
	ship.stats.boost_cooldown = ship.base_stats.boost_cooldown
	ship.stats.max_power = ship.base_stats.max_power
	ship.stats.power_regen = ship.base_stats.power_regen
	ship.stats.dodge_length = ship.base_stats.dodge_length
	ship.stats.dodge_cooldown = ship.base_stats.dodge_cooldown
	ship.stats.dodge_invuln = ship.base_stats.dodge_invuln
	ship.stats.max_hull = ship.base_stats.max_hull
	ship.stats.hull_armor = ship.base_stats.hull_armor
	ship.stats.max_shield = ship.base_stats.max_shield
	ship.stats.shield_regen = ship.base_stats.shield_regen
	
	# Reset weapon stats to base
	for weapon in ship.weapons:
		if weapon.base_stat:
			weapon.wstat.fire_rate = weapon.base_stat.fire_rate
			weapon.wstat.power_cost = weapon.base_stat.power_cost
			weapon.wstat.damage = weapon.base_stat.damage
			weapon.wstat.split_count = weapon.base_stat.split_count
			weapon.wstat.spread_angle = weapon.base_stat.spread_angle

func _apply_ship_mods(ship: PlayerShip) -> void:
	# Apply ship stat modifiers
	for mod in mods:
		ship.stats.top_speed *= mod.top_speed_mult
		ship.stats.acceleration *= mod.acceleration_mult
		ship.stats.turn_rate *= mod.turn_rate_mult
		ship.stats.boost_speed *= mod.boost_speed_mult
		ship.stats.boost_cooldown *= mod.boost_cooldown_mult
		ship.stats.max_power *= mod.max_power_mult
		ship.stats.power_regen *= mod.power_regen_mult
		ship.stats.dodge_length *= mod.dodge_length_mult
		ship.stats.dodge_cooldown *= mod.dodge_cooldown_mult
		ship.stats.dodge_invuln *= mod.dodge_invuln_mult
		ship.stats.max_hull *= mod.max_hull_mult
		ship.stats.hull_armor *= mod.hull_armor_mult
		ship.stats.max_shield *= mod.max_shield_mult
		ship.stats.shield_regen *= mod.shield_regen_mult

func _apply_weapon_mods(ship: PlayerShip) -> void:
	for weapon in ship.weapons:
		# Apply mods
		for mod in mods:
			weapon.wstat.fire_rate *= mod.fire_rate_mult
			weapon.wstat.power_cost *= mod.power_cost_mult
			weapon.wstat.damage *= mod.damage_mult
			weapon.wstat.split_count += mod.split_count
			weapon.wstat.spread_angle = max(weapon.wstat.spread_angle, mod.spread_angle)
			weapon.wstat.pierce += mod.pierce_count
			weapon.wstat.chain += mod.chain_count
			weapon.wstat.chain_distance += mod.chain_distance
			weapon.wstat.explode += mod.explode_radius
			weapon.wstat.bounce += mod.bounce_count
			weapon.wstat.knockback_force += mod.knockback_force
			weapon.wstat.projectile_speed *= mod.projectile_speed_mult
			weapon.wstat.reload_time *= mod.reload_time_mult
