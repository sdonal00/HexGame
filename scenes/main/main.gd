extends Node

var game_scene: PackedScene = preload("res://scenes/game/game.tscn")
var background_scene: PackedScene = preload("res://scenes/background/random_background.tscn")
var ff = false

func _on_turret_create_projectiles(projectile):
	projectile.connect("hit_timer_reset", hit_timer_reset)
	$Game/Projectiles.add_child(projectile)
	hit_timer_reset()
	
func _on_show_ff_button():
	$Menu/GameHud/FFButton.visible = true

func _ready():
	$Menu/GameHud.visible = true
	$Menu/GameHud/Highscore.set_text("Best " + str(Globals.highscore))

func hit_timer_reset():
	$Game/HitTimer.stop()
	$Game/HitTimer.start()

func kill_children(node: Node):
	var children = node.get_children()
	for child in children:
		child.queue_free()

func _on_hit_timer_timeout():
	start_round()
		
func _on_level_1_all_hexes_killed():
	start_round()
	
func start_round():
	if ff:
		stop_fast_forward()
	Globals.can_ff = false
	Globals.can_shoot = true
	$Menu/GameHud/FFButton.visible = false
	$Game/HitTimer.stop()
	kill_children($Game/Projectiles)
	$Game/Level/Level1.start_next_round()
	$Menu/GameHud/Highscore.set_text("Best " + str(Globals.highscore))
	
func _on_level_1_update_score():
	$Menu/GameHud/Points.set_text(str(Globals.points))
	if Globals.points > Globals.highscore:
		Globals.highscore = Globals.points
	#$Menu/GameHud/Highscore.set_text("Best " + str(Globals.highscore))
	
func _on_level_1_projectile_deleted():
	#1 before last projectile is freed
	if $Game/Projectiles.get_child_count() == 1:
		start_round()

func _on_level_1_game_over():
	$Menu/AdView/Rewarded.load_ad()
	$Menu/GameOverMenu.visible = true

func _on_play_button_pressed():
	Globals.new_game()
	var game = game_scene.instantiate()
	game.connect("level_1_projectile_deleted", _on_level_1_projectile_deleted)
	game.connect("level_1_game_over", _on_level_1_game_over)
	game.connect("level_1_update_score", _on_level_1_update_score)
	game.connect("level_1_all_hexes_killed", _on_level_1_all_hexes_killed)
	game.connect("hit_timer_timeout", _on_hit_timer_timeout)
	game.connect("turret_create_projectiles", _on_turret_create_projectiles)
	game.connect("show_ff_button", _on_show_ff_button)
	add_child(game)
	move_child(game, 0)
	$Menu/HomeMenu.visible = false
	$Menu/GameHud.visible = true
	$Menu/GameHud/Points.set_text("0")
	$Menu/HomeMenu/RandomBackground.queue_free()
	if Globals.paused:
		$Menu.unpause_game()

func _on_quit_button_pressed():
	remove_child(get_child(0))
	$Menu/GameOverMenu.visible = false
	$Menu/HomeMenu.visible = true
	$Menu/GameHud.visible = false
	$Menu/PauseMenu.visible = false
	Globals.current_round = 1
	var bg = background_scene.instantiate()
	$Menu/HomeMenu.add_child(bg)
	$Menu/HomeMenu.move_child(bg, 0)

func set_proj_speed(modifier, mul):
	var projectiles = $Game/Projectiles.get_children()
	for projecile in projectiles:
		if mul:
			projecile.linear_velocity *= modifier
		else:
			projecile.linear_velocity /= modifier

func _on_continue_button_pressed():
	$Menu/AdView.visible = true
	$Menu/AdView/Rewarded.show_ad()

func fast_forward():
	ff = true
	set_proj_speed(3, true)
	
func stop_fast_forward():
	ff = false
	set_proj_speed(3, false)

func _on_ff_button_pressed():
	if Globals.can_ff:
		if ff:
			stop_fast_forward()
		else:
			fast_forward()

func _on_rewarded_earned_respawn():
	$Menu/GameOverMenu.visible = false
	#Logic to show ad
	Globals.game_over = false
