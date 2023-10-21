extends CharacterBody2D

signal converted
const EXPECTED_EDGE_OFFSET: int = 48
const EXPECTED_SPRITE_SIZE = 96
const MINIMUM_SPAWN_Y = EXPECTED_EDGE_OFFSET + 24
const MAXIMUM_SPAWN_Y = floor(Global.PLAYABLE_BOTTOM_EDGE / 2.0) - EXPECTED_SPRITE_SIZE
const SPEED: float = 150.0
@export var converted_sounds: Array[AudioStreamWAV]
@export var fire_sounds: Array[AudioStreamWAV]
var gaysplosion_ended: bool = false
var gaysplosion_scene: PackedScene = preload("res://scenes/gaysplosion.tscn")
var gun_has_entered_playable_area: bool = false
var straightness: int = 6
@onready var fire_timer: Timer = $FireTimer
@onready var converted_player: AudioStreamPlayer = $ConvertedPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_size: float = sprite.get_rect().size[0]
@onready var edge_offset: float = ceilf(sprite_size / 2.0)


func _ready() -> void:
	start_fire_timer()


func _physics_process(delta: float) -> void:
	move_and_slide()

	if !gun_has_entered_playable_area and !gun_is_out_of_bounds():
		gun_has_entered_playable_area = true

	if gun_has_entered_playable_area and gun_is_out_of_bounds():
		fire_timer.stop()

	if is_out_of_bounds():
		queue_free()

	if straightness == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
		modulate.a -= delta

	if gaysplosion_ended and converted_player.playing == false:
		queue_free()


func _on_fire_timer_timeout() -> void:
	fire()
	start_fire_timer()


func fire() -> void:
	var bullet: RigidBody2D = Global.bullet_scene.instantiate()
	var fire_sound_index = 0 if straightness > 3 else 1
	bullet.init(self, fire_sounds[fire_sound_index])


func gun_is_out_of_bounds() -> bool:
	return gun_is_out_of_bounds_left() or gun_is_out_of_bounds_right()


func gun_is_out_of_bounds_left() -> bool:
	return x_position() - Global.EXPECTED_BULLET_EDGE_OFFSET < Global.PLAYABLE_LEFT_EDGE


func gun_is_out_of_bounds_right() -> bool:
	return x_position() + Global.EXPECTED_BULLET_EDGE_OFFSET > Global.PLAYABLE_RIGHT_EDGE


func is_out_of_bounds() -> bool:
	return is_out_of_bounds_left() or is_out_of_bounds_right()


func is_out_of_bounds_left() -> bool:
	return x_position() + edge_offset <= Global.PLAYABLE_LEFT_EDGE


func is_out_of_bounds_right() -> bool:
	return x_position() - edge_offset >= Global.PLAYABLE_RIGHT_EDGE


func on_converted() -> void:
	sprite.region_rect = Rect2(sprite_size * 2 + 2, 0, sprite_size, sprite_size)
	fire_timer.stop()
	set_collision_layer_value(2, false)
	play_gaysplosion()
	play_converted_sound()
	emit_signal("converted")


func on_gaysplosion_ended() -> void:
	gaysplosion_ended = true


func on_hit() -> void:
	straightness -= 1

	if straightness == 3:
		sprite.region_rect = Rect2(sprite_size + 1, 0, sprite_size, sprite_size)
	elif straightness == 0:
		on_converted()


func play_converted_sound() -> void:
	converted_player.stream = converted_sounds.pick_random()
	converted_player.play()


func play_gaysplosion() -> void:
	var gaysplosion: CPUParticles2D = gaysplosion_scene.instantiate()
	gaysplosion.global_position = Vector2(x_position(), y_position())
	gaysplosion.connect("tree_exited", on_gaysplosion_ended)
	get_tree().get_root().add_child(gaysplosion)
	gaysplosion.emitting = true


func start_fire_timer() -> void:
	fire_timer.wait_time = randf_range(0.5, 2)
	fire_timer.start()


func x_position() -> float:
	return self.global_position[0]


func y_position() -> float:
	return self.global_position[1]
