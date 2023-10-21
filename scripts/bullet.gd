extends RigidBody2D

enum Edge { BOTTOM, TOP }
const EXPECTED_EDGE_OFFSET: int = 8
const SPRITE_COUNT: int = 6
const SPRITE_SCALE: int = 4
@export var player_fire_sounds: Array[AudioStreamWAV]
var sprite_index: int
@onready var sfx_player: AudioStreamPlayer = $SfxPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_size: float = sprite.get_rect().size[0]
@onready var size: float = sprite_size * SPRITE_SCALE
@onready var edge_offset: float = ceilf(size / 2.0)


func _ready() -> void:
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


func init(parent: CharacterBody2D) -> void:
	if parent.get_collision_layer_value(1):
		set_collision_mask_value(1, false)
	elif parent.get_collision_layer_value(2):
		set_collision_mask_value(2, false)

	if parent.name == "Player":
		global_position = Vector2(
			parent.x_position(), parent.y_position() - Global.CHARACTER_GUN_OFFSET - edge_offset
		)
		sprite_index = randi() % SPRITE_COUNT
	else:
		global_position = Vector2(
			parent.x_position(), parent.y_position() + Global.CHARACTER_GUN_OFFSET + edge_offset
		)
		reverse_direction()
		sprite_index = SPRITE_COUNT

	parent.get_tree().get_root().add_child(self)


func is_off_screen() -> bool:
	return is_off_screen_bottom() or is_off_screen_top()


func is_off_screen_bottom() -> bool:
	return y_position() - edge_offset >= Global.PLAYABLE_BOTTOM_EDGE


func is_off_screen_top() -> bool:
	return y_position() + edge_offset <= Global.PLAYABLE_TOP_EDGE


func play_fire_sound() -> void:
	sfx_player.stream = player_fire_sounds.pick_random()
	sfx_player.play()


func reverse_direction() -> void:
	linear_velocity.y *= -1


func y_position() -> float:
	return self.global_position[1]
