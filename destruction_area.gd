extends Area3D
class_name DestructionZone

func _ready() -> void:
	collision_layer = 0
	collision_mask = 768
	print("DestructionZone initialized at position: ", global_position)

func _on_body_entered(body: Node3D) -> void:
	print("DestructionZone hit by: ", body.name, " at position: ", body.global_position)
	if body is Enemy:
		print("DestructionZone killing enemy: ", body.name)
		body.die_unscored()
	#if body is Bullet:
		#print("DestructionZone killing bullet: ", body.name)
		#body.die_unscored()
