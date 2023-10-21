extends Node2D

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


func _ready() -> void:
	spawn_enemy()


func spawn_enemy() -> void:
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	enemy.global_position.y = randf_range(enemy.MINIMUM_SPAWN_Y, enemy.MAXIMUM_SPAWN_Y)
	set_enemy_direction(enemy)
	get_tree().get_root().add_child.call_deferred(enemy)


func set_enemy_direction(enemy: CharacterBody2D) -> void:
	if randi_range(0, 1) == 0:
		set_enemy_direction_left(enemy)
	else:
		set_enemy_direction_right(enemy)


func set_enemy_direction_left(enemy: CharacterBody2D) -> void:
	enemy.global_position.x = -enemy.EXPECTED_EDGE_OFFSET
	enemy.velocity.x = enemy.SPEED


func set_enemy_direction_right(enemy: CharacterBody2D) -> void:
	enemy.global_position.x = Global.PLAYABLE_RIGHT_EDGE + enemy.EXPECTED_EDGE_OFFSET
	enemy.velocity.x = -enemy.SPEED


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()
	enemy_spawn_timer.wait_time = randf_range(2, 6)
	enemy_spawn_timer.start()
