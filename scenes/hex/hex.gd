extends StaticBody2D

@export var health: int = 1

func _ready():
	modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),1)
	
func _physics_process(delta):
	if health <= 0:
		queue_free()
	
func hit():
	health -= 1
	$Label.set_text(str(health))
