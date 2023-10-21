extends Node2D

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


func _ready() -> void:
	spawn_enemy()


func _process(_delta: float) -> void:
	pass


func spawn_enemy() -> void:
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	enemy.global_position = Vector2(
		-enemy.EXPECTED_ENEMY_EDGE_OFFSET, enemy.EXPECTED_ENEMY_EDGE_OFFSET + 24
	)
	get_tree().get_root().add_child.call_deferred(enemy)


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()
	enemy_spawn_timer.wait_time = randf_range(2, 6)
	enemy_spawn_timer.start()
