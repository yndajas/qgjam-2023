extends CharacterBody2D

const PLAYABLE_LEFT_EDGE: int = 0
const PLAYABLE_RIGHT_EDGE: int = 1280
const PLAYER_GUN_OFFSET: int = 40
const SPEED: float = 600.0
@onready var player_edge_offset: float = $AnimatedSprite2D.get_sprite_frames().get_frame_texture("default", 0).get_size()[0] / 2.0
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

enum Edge { LEFT, RIGHT }

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 5)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	move_and_slide()
	reset_if_beyond_edge()

	if Input.is_action_just_pressed("fire"):
		fire()

func fire() -> void:
	var bullet: RigidBody2D = bullet_scene.instantiate()
	bullet.global_position = Vector2(x_position(), y_position() - PLAYER_GUN_OFFSET - bullet.EXPECTED_BULLET_EDGE_OFFSET)
	get_tree().get_root().add_child(bullet)

func has_hit_edge(edge: int) -> bool:
	if is_left_edge(edge):
		return x_position() - player_edge_offset < PLAYABLE_LEFT_EDGE
	else:
		return x_position() + player_edge_offset > PLAYABLE_RIGHT_EDGE

func is_left_edge(edge: int) -> bool:
	return edge == Edge.LEFT

func reset_if_beyond_edge() -> void:
	if has_hit_edge(Edge.LEFT):
		reset_to_edge(Edge.LEFT)
	elif has_hit_edge(Edge.RIGHT):
		reset_to_edge(Edge.RIGHT)

func reset_to_edge(edge: int) -> void:
	var target_x_position: float

	if is_left_edge(edge):
		target_x_position = ceil(PLAYABLE_LEFT_EDGE + player_edge_offset)
	else:
		target_x_position = floor(PLAYABLE_RIGHT_EDGE - player_edge_offset)

	self.global_position = Vector2(target_x_position, y_position())

func x_position() -> float:
	return self.global_position[0]

func y_position() -> float:
	return self.global_position[1]
