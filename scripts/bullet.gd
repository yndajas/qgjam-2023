extends RigidBody2D

enum Edge { BOTTOM, TOP }
const EXPECTED_BULLET_EDGE_OFFSET: int = 8
const SPRITE_COUNT: int = 6
const SPRITE_SCALE: int = 4
@export var fire_sounds: Array[AudioStreamWAV]
@onready var sfx_player: AudioStreamPlayer = $SfxPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_size: float = sprite.get_rect().size[0]
@onready var bullet_size: float = sprite_size * SPRITE_SCALE
@onready var bullet_edge_offset: float = ceilf(bullet_size / 2.0)


func _ready() -> void:
	var sprite_index: int = randi() % SPRITE_COUNT
	sprite.region_rect = Rect2(0, sprite_index * sprite_size, sprite_size, sprite_size)
	sprite.scale = Vector2(SPRITE_SCALE, SPRITE_SCALE)
	play_fire_sound()


func _physics_process(_delta: float) -> void:
	if is_off_screen():
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.has_method("on_hit"):
		body.on_hit()
		queue_free()


func is_off_screen() -> bool:
	return is_off_screen_bottom() or is_off_screen_top()


func is_off_screen_bottom() -> bool:
	return y_position() - bullet_edge_offset > Global.PLAYABLE_BOTTOM_EDGE


func is_off_screen_top() -> bool:
	return y_position() + bullet_edge_offset < Global.PLAYABLE_TOP_EDGE


func play_fire_sound() -> void:
	sfx_player.stream = fire_sounds.pick_random()
	sfx_player.play()


func y_position() -> float:
	return self.global_position[1]
