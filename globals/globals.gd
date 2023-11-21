extends Node

var paused: bool = false
var current_round: int = 1
var points: int = 0
var mouse_in_shooting_zone: bool = false
var can_shoot: bool = true
var game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func new_game():
	current_round = 1
	points = 0
	mouse_in_shooting_zone = false
	can_shoot = true
	game_over = false
