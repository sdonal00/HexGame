extends Node2D

signal level_1_projectile_deleted()
signal level_1_game_over()
signal level_1_update_score()
signal level_1_all_hexes_killed()
signal hit_timer_timeout()
signal turret_create_projectiles(projectile)

func _on_level_1_all_hexes_killed():
	level_1_all_hexes_killed.emit()

func _on_level_1_game_over():
	level_1_game_over.emit()

func _on_level_1_projectile_deleted():
	level_1_projectile_deleted.emit()

func _on_level_1_update_score():
	level_1_update_score.emit()

func _on_turret_create_projectiles(projectile):
	turret_create_projectiles.emit(projectile)

func _on_hit_timer_timeout():
	hit_timer_timeout.emit()
