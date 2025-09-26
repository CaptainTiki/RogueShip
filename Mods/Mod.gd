class_name Mod
extends Resource

@export_category("General")
@export var name: String = "Unnamed Mod"
@export var size: int = 10  # For carrier Tetris (10-30 slots)

@export_category("Weapon Buffs")
@export var fire_rate_mult: float = 1.0  # Multiplier for fire_rate (lower = faster)
@export var power_cost_mult: float = 1.0  # Multiplier for power_cost
@export var damage_mult: float = 1.0  # Multiplier for damage
@export var split_count: int = 0  # Number of extra projectiles
@export var spread_angle: float = 0.0  # Spread angle in degrees
@export var chain_count: int = 0  # Number of chain jumps
@export var chain_distance: float = 0.0  # Max distance for chain jumps
@export var explode_radius: float = 0.0  # AOE radius on projectile death
@export var knockback_force: float = 0.0  # Force applied to enemies on hit
@export var pierce_count: int = 0  # Number of enemies to pierce
@export var bounce_count: int = 0  # Number of bounces
@export var projectile_speed_mult: float = 1.0  # Multiplier for projectile speed
@export var reload_time_mult: float = 1.0  # Multiplier for reload time

@export_category("Ship Buffs")
@export var top_speed_mult: float = 1.0  # Multiplier for ship top speed
@export var acceleration_mult: float = 1.0  # Multiplier for acceleration
@export var turn_rate_mult: float = 1.0  # Multiplier for turn rate
@export var boost_speed_mult: float = 1.0  # Multiplier for boost speed
@export var boost_cooldown_mult: float = 1.0  # Multiplier for boost cooldown
@export var max_power_mult: float = 1.0  # Multiplier for max power
@export var power_regen_mult: float = 1.0  # Multiplier for power regen
@export var dodge_length_mult: float = 1.0  # Multiplier for dodge distance
@export var dodge_cooldown_mult: float = 1.0  # Multiplier for dodge cooldown
@export var dodge_invuln_mult: float = 1.0  # Multiplier for dodge invuln duration
@export var max_hull_mult: float = 1.0  # Multiplier for max hull
@export var hull_armor_mult: float = 1.0  # Multiplier for hull armor
@export var max_shield_mult: float = 1.0  # Multiplier for max shield
@export var shield_regen_mult: float = 1.0  # Multiplier for shield regen

@export_category("Enemy Buffs")
@export var enemy_health_mult: float = 1.0
@export var enemy_fire_rate: float = 1.0
@export var enemy_accel: float = 1.0

@export_category("Gameplay Buffs")
@export var scrap_multiplier: float = 1.0
