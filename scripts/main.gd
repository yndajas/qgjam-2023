extends Node2D

var collected_flags: Array[int]
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var flag_scene: PackedScene = preload("res://scenes/flag.tscn")
var uncollected_flags: Array[int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
var score: int = 0
@onready var converts_count_text: RichTextLabel = $InformationPanel/ConvertsCountText
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var information_panel: ColorRect = $InformationPanel
@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	uncollected_flags.shuffle()
	prepare_information_panel()
	spawn_enemy()
	player.connect("hit", on_player_hit)


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()
	enemy_spawn_timer.wait_time = randf_range(2, 6)
	enemy_spawn_timer.start()


func collect_flag() -> void:
	var index = randi_range(0, uncollected_flags.size() - 1)
	var collected_flag = uncollected_flags[index]
	collected_flags.push_back(collected_flag)
	uncollected_flags = uncollected_flags.filter(
		func(uncollected_flag): return uncollected_flag != collected_flag
	)
	render_flags()


func lose_flag() -> void:
	var flag = collected_flags.pop_back()
	var index_to_insert_at: int = randi_range(0, uncollected_flags.size())
	uncollected_flags.insert(index_to_insert_at, flag)
	render_flags()


func on_enemy_converted() -> void:
	score += 1
	if collected_flags.size() < 14:
		collect_flag()
	update_score_counter()


func on_player_hit() -> void:
	if collected_flags.size():
		lose_flag()
	else:
		print_debug("game over")


func prepare_information_panel() -> void:
	information_panel.size.x = Global.PLAYABLE_LEFT_EDGE
	for panel_child in information_panel.get_children():
		panel_child.size.x = Global.PLAYABLE_LEFT_EDGE
	update_score_counter()


func render_flags() -> void:
	for child in information_panel.get_children():
		if child.get_class() == "Sprite2D":
			child.queue_free()

	var index: int = 0
	for flag in collected_flags:
		var sprite_column = floor(flag / 2.0)
		var sprite_row = flag % 2
		var flag_sprite: Sprite2D = flag_scene.instantiate()
		flag_sprite.scale = Vector2(Global.FLAG_SCALE, Global.FLAG_SCALE)
		flag_sprite.region_rect = Rect2(
			sprite_column * (Global.FLAG_SPRITE_WIDTH + Global.FLAG_SPRITE_GRID_GAP),
			sprite_row * (Global.FLAG_SPRITE_HEIGHT + Global.FLAG_SPRITE_GRID_GAP),
			Global.FLAG_SPRITE_WIDTH,
			Global.FLAG_SPRITE_HEIGHT
		)

		var render_column = index % 2
		var render_row = floor(index / 2.0)
		flag_sprite.global_position = Vector2(
			(
				render_column * (Global.EXPECTED_FLAG_WIDTH + Global.FLAG_RENDER_GRID_GAP)
				+ Global.EXPECTED_FLAG_EDGE_OFFSET_X
				+ Global.FLAG_AREA_START_X
			),
			(
				render_row * (Global.EXPECTED_FLAG_HEIGHT + Global.FLAG_RENDER_GRID_GAP)
				+ Global.EXPECTED_FLAG_EDGE_OFFSET_Y
				+ Global.FLAG_AREA_START_Y
			),
		)

		information_panel.add_child(flag_sprite)

		index += 1


func spawn_enemy() -> void:
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	enemy.global_position.y = randf_range(enemy.MINIMUM_SPAWN_Y, enemy.MAXIMUM_SPAWN_Y)
	set_enemy_direction(enemy)
	enemy.connect("converted", on_enemy_converted)
	enemy_spawn_timer.add_sibling.call_deferred(enemy)


func set_enemy_direction(enemy: CharacterBody2D) -> void:
	if randi_range(0, 1) == 0:
		set_enemy_direction_left(enemy)
	else:
		set_enemy_direction_right(enemy)


func set_enemy_direction_left(enemy: CharacterBody2D) -> void:
	enemy.global_position.x = Global.PLAYABLE_LEFT_EDGE - enemy.EXPECTED_EDGE_OFFSET
	enemy.velocity.x = enemy.SPEED


func set_enemy_direction_right(enemy: CharacterBody2D) -> void:
	enemy.global_position.x = Global.PLAYABLE_RIGHT_EDGE + enemy.EXPECTED_EDGE_OFFSET
	enemy.velocity.x = -enemy.SPEED


func update_score_counter() -> void:
	converts_count_text.text = "[center]" + "%04d" % score
