extends Node3D
class_name ScrapPickup

signal picked_up

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerShip:
		PlayerData.credits +=1
		picked_up.emit()
		queue_free()  # Remove the pickup
