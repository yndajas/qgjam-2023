extends Node2D

var alpha: float = 1.0
var alpha_decreasing: bool = true
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var start_controls_text: RichTextLabel = $StartControlsText


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("start_game"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")

	if alpha == 0:
		alpha_decreasing = false
	elif alpha == 1:
		alpha_decreasing = true

	if alpha_decreasing:
		alpha = max(alpha - delta / 1.5, 0)
	else:
		alpha = min(alpha + delta / 1.5, 1)

	player_sprite.modulate.a = alpha
	start_controls_text.modulate.a = alpha
