extends Node2D

func _on_despawn_zone_body_entered(body):
	print(body, "here")
	body.queue_free()
