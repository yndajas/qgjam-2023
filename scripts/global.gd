extends Node

const CHARACTER_GUN_OFFSET: int = 40
const EXPECTED_BULLET_EDGE_OFFSET: int = 8
const PLAYABLE_BOTTOM_EDGE: int = 720
const PLAYABLE_LEFT_EDGE: int = 240
const PLAYABLE_RIGHT_EDGE: int = 1280
const PLAYABLE_TOP_EDGE: int = 0
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
