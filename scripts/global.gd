extends Node

const CHARACTER_GUN_OFFSET: int = 40
const EXPECTED_BULLET_EDGE_OFFSET: int = 8
const FLAG_SCALE: int = 4
const FLAG_SPRITE_COUNT: int = 14
const FLAG_SPRITE_HEIGHT: int = 12
const FLAG_SPRITE_WIDTH: int = 16
const EXPECTED_FLAG_HEIGHT: int = FLAG_SPRITE_HEIGHT * FLAG_SCALE
const EXPECTED_FLAG_WIDTH: int = FLAG_SPRITE_WIDTH * FLAG_SCALE
const EXPECTED_FLAG_EDGE_OFFSET_X: int = roundi(EXPECTED_FLAG_WIDTH / 2.0)
const EXPECTED_FLAG_EDGE_OFFSET_Y: int = roundi(EXPECTED_FLAG_HEIGHT / 2.0)
const FLAG_RENDER_GRID_GAP: int = 16
const FLAG_RENDER_MAXIMUM_ROWS: int = ceili(FLAG_SPRITE_COUNT / 2.0)
const FLAG_SPRITE_GRID_GAP: int = 1
const MAXIMUM_CHAOS_LEVEL: int = 20
const PLAYABLE_BOTTOM_EDGE: int = 720
const PLAYABLE_LEFT_EDGE: int = 240
const PLAYABLE_RIGHT_EDGE: int = 1280
const PLAYABLE_TOP_EDGE: int = 0
const FLAG_AREA_START_X: int = roundi(
	(PLAYABLE_LEFT_EDGE - (EXPECTED_FLAG_WIDTH * 2 + FLAG_RENDER_GRID_GAP)) / 2.0
)
const FLAG_AREA_START_Y: int = 192
const EXPECTED_FLAG_AREA_END_Y: int = (
	FLAG_AREA_START_Y
	+ (
		(FLAG_RENDER_MAXIMUM_ROWS - 1) * (EXPECTED_FLAG_HEIGHT + FLAG_RENDER_GRID_GAP)
		+ EXPECTED_FLAG_HEIGHT
	)
)
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var chaos_level: int = 0
var game_over: bool = false
var score: int = 0


func chaos_bound(start_bound: float, minimum_bound: float) -> float:
	var step: float = (start_bound - minimum_bound) / MAXIMUM_CHAOS_LEVEL
	return start_bound - step * chaos_level
