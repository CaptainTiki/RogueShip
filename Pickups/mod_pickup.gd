extends Area3D
class_name ModPickup

signal picked_up

@export var mod: Mod

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerShip and body.ship_mod_manager:
		body.ship_mod_manager.add_mod(mod)
		body.ship_mod_manager.update_stats(body)
		print("pickup mod: ", mod.name)
		picked_up.emit()
		queue_free()
