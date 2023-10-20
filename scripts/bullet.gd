extends RigidBody2D

const PLAYABLE_BOTTOM_EDGE: int = 720
const PLAYABLE_TOP_EDGE: int = 0
const SPRITE_COUNT: int = 6
@onready var sprite_size: int = $Sprite2D.get_rect().size[0]
@onready var bullet_edge_offset: int = ceili(sprite_size / 2.0)

enum Edge { BOTTOM, TOP }

func _ready() -> void:
	var sprite_index: int = randi() % SPRITE_COUNT
	$Sprite2D.region_rect = Rect2(0, sprite_index * sprite_size, sprite_size, sprite_size)

func _physics_process(_delta: float) -> void:
	if is_off_screen():
		queue_free()

func is_off_screen() -> bool:
	return is_off_screen_bottom() or is_off_screen_top()

func is_off_screen_bottom() -> bool:
	return y_position() - bullet_edge_offset > PLAYABLE_BOTTOM_EDGE

func is_off_screen_top() -> bool:
	return y_position() + bullet_edge_offset < PLAYABLE_TOP_EDGE

func y_position() -> int:
	return self.global_position[1]
