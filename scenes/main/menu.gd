extends Control

func _process(_delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("pause"):
		pause_game()
			
func pause_game():
	if !Globals.paused:
		Globals.paused = true
		get_tree().paused = true
		$PauseMenu.visible = true
	else:
		Globals.paused = false
		get_tree().paused = false
		$PauseMenu.visible = false

func _on_texture_button_pressed():
	print("pressed pause")
	pause_game()
