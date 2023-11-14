extends Node

func _on_turret_create_projectiles(projectile):
	projectile.connect("hit_timer_reset", hit_timer_reset)
	$Game/Projectiles.add_child(projectile)
	hit_timer_reset()

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
	Globals.can_shoot = true
	$Game/HitTimer.stop()
	kill_children($Game/Projectiles)
	$Game/Level/Level1.start_next_round()
	
func _on_level_1_update_score():
	$Menu/GameHud/HBoxContainer/Points.set_text(str(Globals.points))
	
func _on_level_1_projectile_deleted():
	#1 before last projectile is freed
	if $Game/Projectiles.get_child_count() == 1:
		start_round()


func _on_level_1_game_over():
	print("game over")
