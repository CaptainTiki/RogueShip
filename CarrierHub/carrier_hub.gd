extends Node2D
class_name CarrierHub

func _ready() -> void:
	pass

func _on_launch_pressed() -> void:
	var transition = preload("res://UI/Menus/TransitionScene.tscn").instantiate()
	get_tree().root.add_child(transition)
	transition.fade_out()
	await transition.transition_complete
	GameManager.transition_instance = transition
	GameManager.start_level()
	queue_free()
