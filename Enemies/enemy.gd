extends CharacterBody3D
class_name Enemy

@export var max_hull: float = 30.0
@export var speed: float = 10

@onready var hurtbox: Area3D = $HurtBox

var hull: float

func _ready() -> void:
	hull = max_hull

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
			take_damage(bullet.damage)

func _on_hurtbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("terrain"):
		take_damage(GameData.collision_damage)

func take_damage(amount: float) -> void:
	print("hit enemy: ", amount)
	hull = max(0, hull - amount)
	if hull <= 0:
		die()

func die() -> void:
	#TODO: Drop Scrap / Module
	if randf() < 0.75:  # 50% chance
		var pickup = preload("res://Mods/ModPickup.tscn").instantiate()
		pickup.mod = ModManager.get_random_unlocked_mod()
		get_tree().root.add_child(pickup)
		pickup.global_position = global_position
	#TODO: add score to run score
	# Notify room of enemy death
	if get_tree().current_scene is Level:
		get_tree().current_scene.enemy_killed()
	queue_free()  # Remove enemy
