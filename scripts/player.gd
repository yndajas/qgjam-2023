extends CharacterBody2D

const SPEED = 600.0
const PLAYABLE_LEFT_EDGE = 0
const PLAYABLE_RIGHT_EDGE = 1280
@onready var player_edge_offset: int = $AnimatedSprite2D.get_sprite_frames().get_frame_texture("default", 0).get_size()[0] / 2

enum Edge { LEFT, RIGHT }

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 5)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	move_and_slide()
	reset_if_beyond_edge()

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
	var target_x_position: int

	if is_left_edge(edge):
		target_x_position = PLAYABLE_LEFT_EDGE + player_edge_offset
	else:
		target_x_position = PLAYABLE_RIGHT_EDGE - player_edge_offset
		
	self.global_position = Vector2(target_x_position, y_position()) 

func x_position() -> int:
	return self.global_position[0]

func y_position() -> int:
	return self.global_position[1]
