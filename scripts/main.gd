extends Node2D

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")


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