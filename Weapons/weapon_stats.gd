extends Resource
class_name WeaponStats

@export_group("Firing")
@export_subgroup("Visualization")
@export var projo_scene: PackedScene = preload("res://Projectiles/SimpleBullet.tscn")
@export var trail_scene: PackedScene
@export var hit_effect_scene: PackedScene
@export var scale : Vector3 = Vector3.ONE
@export_subgroup("Weapon_Stats")
@export var fire_rate : float = 1.0 #how fast we fire
@export var damage : float = 10.0 #damage on hit
@export var spread_angle : float = 1.0 # how much deviation per projo
@export var life_time : float = 5 #how long before we queue_free the projo
@export var projectiles_per_shot : int = 1
@export var projectile_speed := 20.0
@export var reload_time := 0.0  #0 for instant
@export var power_cost : float = 5.0 #how much do we need to 
@export_subgroup("Behavior")
@export var pierce: int = 0 #how many do we go through before activating Queue_free
@export var chain: int = 0 #if we hit 1, how many do we chain another hit to
@export var chain_distance: float = 0 #how far can we chain a hit to
@export var explode: float = 0 #on queue_free - distance hit_effect damages
@export var bounce: int = 0 #number of bounces before we queuefree
@export var knockback_force: float = 0 #how much force do we apply to an enemy on hit
@export var split_count: int = 0 #when we instantiate a bullet - how many bullets appear
@export var recoil: int = 0 #how much force do we apply to our ship on shoot
