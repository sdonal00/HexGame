extends Node

var paused: bool = false
var current_round: int = 1
var points: int = 0
var mouse_in_shooting_zone: bool = false
var can_shoot: bool = true
var game_over: bool = false
var colors_cool: Array = [
Color(0,128,0),
Color(152,251,152),
Color(32,178,170),
Color(0,255,127),
Color(0,139,139),
Color(0,255,255),
Color(64,224,208),
Color(127,255,212),
Color(0,191,255),
Color(0,0,205)]
var colors_warm: Array = [Color(255,0,255),
Color(255,20,147),
Color(255,140,0),
Color(255,0,0),
Color(255,215,0),
Color(255,255,0),
Color(255,99,71),
Color(240,128,128),
Color(255,160,122),
Color(255,69,0)]
var colors_all: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func new_game():
	current_round = 1
	points = 0
	mouse_in_shooting_zone = false
	can_shoot = true
	game_over = false
