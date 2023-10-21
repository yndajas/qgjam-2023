extends CharacterBody2D

const EXPECTED_EDGE_OFFSET: int = 48
const EXPECTED_SPRITE_SIZE = 96
const MINIMUM_SPAWN_Y = EXPECTED_EDGE_OFFSET + 24
const MAXIMUM_SPAWN_Y = floor(Global.PLAYABLE_BOTTOM_EDGE / 2.0) - EXPECTED_SPRITE_SIZE
const SPEED: float = 150.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_size: float = sprite.get_rect().size[0]
@onready var enemy_edge_offset: float = ceilf(sprite_size / 2.0)


func _ready() -> void:
	velocity.x = SPEED


func _physics_process(_delta: float) -> void:
	move_and_slide()

	if is_off_screen():
		queue_free()


func _on_fire_timer_timeout() -> void:
	fire()


func fire() -> void:
	var bullet: RigidBody2D = Global.bullet_scene.instantiate()
	bullet.init(self)


func is_off_screen() -> bool:
	return x_position() - enemy_edge_offset >= Global.PLAYABLE_RIGHT_EDGE


func on_hit() -> void:
	print_debug("enemy_hit")


func x_position() -> float:
	return self.global_position[0]


func y_position() -> float:
	return self.global_position[1]
