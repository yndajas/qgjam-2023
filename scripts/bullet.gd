extends RigidBody2D

const SPRITE_COUNT: int = 6
@onready var sprite_size: int = $Sprite2D.get_rect().size[0]

func _ready() -> void:
	var sprite_index: int = randi() % SPRITE_COUNT
	$Sprite2D.region_rect = Rect2(0, sprite_index * sprite_size, sprite_size, sprite_size)
