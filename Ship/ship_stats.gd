class_name ShipStats
extends Resource

@export_group("Movement")
@export var top_speed: float = 20 #maximum velocity of the ship
@export var acceleration: float = 20 #how fast do weo get from stop to max speed
@export var turn_rate: float = 5 #radians per sec
@export var boost_speed: float = 20.0 #sprinting for ships
@export var boost_cooldown: float = 3.0 #how much power do we drain from the power pool

@export_group("Energy")
@export var max_power: float = 100.0 #maximum power
@export var power_regen: float = 10.0 #how fast we regen power

@export_group("Defense")
@export var dodge_length: float = 20.0 #how far we fling
@export var dodge_cooldown: float = 1.0 #how long until we can dodge again
@export var dodge_invuln: float = 0.3#how long we're invul for
@export var max_hull: float = 100.0 #max health
@export var hull_armor: float = 0.2 #damage reduction
@export var max_shield: float = 50.0 #how much total shiled we have
@export var shield_regen: float = 5.0 #how fast our sheild repairs
