extends CharacterBody2D

enum Edge { LEFT, RIGHT }
const SPEED: float = 600.0
@export var fire_sounds: Array[AudioStreamWAV]
var bullet_cooldown: float = 0
@onready var player_edge_offset: float = (
	$AnimatedSprite2D.get_sprite_frames().get_frame_texture("default", 0).get_size()[0] / 2.0
)


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 5)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	move_and_slide()
	reset_if_beyond_edge()

	bullet_cooldown -= delta
	if Input.is_action_pressed("fire") && bullet_cooldown <= 0:
		fire()

	if Input.is_action_just_released("fire"):
		bullet_cooldown = 0


func fire() -> void:
	var bullet: RigidBody2D = Global.bullet_scene.instantiate()
	bullet.init(self, fire_sounds.pick_random())
	bullet_cooldown = 0.2


func has_hit_edge(edge: int) -> bool:
	if is_left_edge(edge):
		return x_position() - player_edge_offset < Global.PLAYABLE_LEFT_EDGE

	return x_position() + player_edge_offset > Global.PLAYABLE_RIGHT_EDGE


func is_left_edge(edge: int) -> bool:
	return edge == Edge.LEFT


func on_hit() -> void:
	print_debug("player_hit")


func reset_if_beyond_edge() -> void:
	if has_hit_edge(Edge.LEFT):
		reset_to_edge(Edge.LEFT)
	elif has_hit_edge(Edge.RIGHT):
		reset_to_edge(Edge.RIGHT)


func reset_to_edge(edge: int) -> void:
	var target_x_position: float

	if is_left_edge(edge):
		target_x_position = ceilf(Global.PLAYABLE_LEFT_EDGE + player_edge_offset)
	else:
		target_x_position = floor(Global.PLAYABLE_RIGHT_EDGE - player_edge_offset)

	self.global_position = Vector2(target_x_position, y_position())


func x_position() -> float:
	return self.global_position[0]


func y_position() -> float:
	return self.global_position[1]
