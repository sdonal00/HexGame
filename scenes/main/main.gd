extends Node
#Todo: generate rows, move rows each round, try and fit hexes to screen
func _on_turret_create_projectiles(projectile):
	$Game/Projectiles.add_child(projectile)
