extends CharacterBody2D

const EXPECTED_EDGE_OFFSET: int = 48
const EXPECTED_SPRITE_SIZE = 96
const MINIMUM_SPAWN_Y = EXPECTED_EDGE_OFFSET + 24
const MAXIMUM_SPAWN_Y = floor(Global.PLAYABLE_BOTTOM_EDGE / 2.0) - EXPECTED_SPRITE_SIZE
const SPEED: float = 150.0
var gaysplosion_scene: PackedScene = preload("res://scenes/gaysplosion.tscn")
var straightness: int = 6
@onready var fire_timer: Timer = $FireTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_size: float = sprite.get_rect().size[0]
@onready var enemy_edge_offset: float = ceilf(sprite_size / 2.0)


func _ready() -> void:
	velocity.x = SPEED
	start_fire_timer()


func _physics_process(_delta: float) -> void:
	move_and_slide()

	if is_off_screen():
		queue_free()

	if straightness == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)


func _on_fire_timer_timeout() -> void:
	fire()
	start_fire_timer()


func fire() -> void:
	var bullet: RigidBody2D = Global.bullet_scene.instantiate()
	bullet.init(self)


func is_off_screen() -> bool:
	return x_position() - enemy_edge_offset >= Global.PLAYABLE_RIGHT_EDGE


func on_gaysplosion_ended() -> void:
	queue_free()


func on_hit() -> void:
	straightness -= 1

	if straightness == 3:
		sprite.region_rect = Rect2(sprite_size + 1, 0, sprite_size, sprite_size)
	elif straightness == 0:
		sprite.region_rect = Rect2(sprite_size * 2 + 2, 0, sprite_size, sprite_size)
		fire_timer.stop()
		set_collision_layer_value(2, false)
		play_gaysplosion()


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
