extends Node

	
func _on_turret_create_projectiles(projectile):
	$Game/Projectiles.add_child(projectile)
