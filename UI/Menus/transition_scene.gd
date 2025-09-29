extends CanvasLayer

@export var fade_speed: float = 1.0

@onready var color_rect: ColorRect = $ColorRect
@onready var loading_tex: TextureRect = $LoadingTexture
@onready var anim_player: AnimationPlayer = $AnimationPlayer

signal transition_complete

func _ready() -> void:
	loading_tex.visible = false
	anim_player.get_animation("fade_to_black").length = fade_speed
	anim_player.get_animation("fade_to_transparent").length = fade_speed

func fade_out() -> void:
	anim_player.play("fade_to_black")
	await anim_player.animation_finished
	loading_tex.visible = true
	anim_player.play("fade_in_loading_screen")
	await anim_player.animation_finished
	emit_signal("transition_complete")

func fade_in() -> void:
	anim_player.play("fade_out_loading_screen")
	await anim_player.animation_finished
	loading_tex.visible = false
	anim_player.play("fade_to_transparent")
	await anim_player.animation_finished
	emit_signal("transition_complete")
	queue_free()
