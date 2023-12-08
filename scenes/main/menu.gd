extends Control

func _process(_delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("pause"):
		handle_pause_toggle()
			
func pause_game():
	Globals.paused = true
	get_tree().paused = true
	$PauseMenu.visible = true

func unpause_game():
	Globals.paused = false
	get_tree().paused = false
	$PauseMenu.visible = false

func _on_texture_button_pressed():
	handle_pause_toggle()

func handle_pause_toggle():
	if Globals.paused:
		unpause_game()
	else:
		pause_game()

func _on_resume_button_pressed():
	unpause_game()

func _on_rewarded_hide_ad():
	$AdView.visible = false
