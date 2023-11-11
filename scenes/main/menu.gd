extends Control

func _process(_delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("pause"):
		if !Globals.paused:
			Globals.paused = true
			get_tree().paused = true
		else:
			Globals.paused = false
			get_tree().paused = false
