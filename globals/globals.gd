extends Node

var paused: bool = false
var current_round: int = 1
var points: int = 0
var mouse_in_shooting_zone: bool = false
var can_shoot: bool = true
var game_over: bool = false
var colors_cool: Array = [
Color8(0,128,0),
Color8(152,251,152),
Color8(32,178,170),
Color8(0,255,127),
Color8(0,139,139),
Color8(0,255,255),
Color8(64,224,208),
Color8(127,255,212),
Color8(0,191,255),
Color8(0,0,205)]
var colors_warm: Array = [
Color8(255,0,255),
Color8(255,20,147),
Color8(255,140,0),
Color8(255,0,0),
Color8(255,215,0),
Color8(255,255,0),
Color8(255,99,71),
Color8(240,128,128),
Color8(255,160,122),
Color8(255,69,0)]
var colors_all: Array = []

var selected_colors = colors_cool + colors_warm

var highscore = 0
var can_ff = false
var file_name = "user://highscore.dat"

func load_highscore():
	if FileAccess.file_exists(file_name):
		var file = FileAccess.open(file_name, FileAccess.READ)
		highscore = int(file.get_as_text())
	else:
		save_highscore()

func save_highscore():
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(str(highscore))

func _ready():
	load_highscore()

func new_game():
	current_round = 1
	points = 0
	mouse_in_shooting_zone = false
	can_shoot = true
	game_over = false
