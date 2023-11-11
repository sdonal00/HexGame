extends RigidBody2D

var speed: int
var direction: Vector2
var stuck: bool = false

func _ready():
	linear_velocity = direction * speed
	
func _physics_process(delta):
	check_velocity()
	if linear_velocity.abs().x < 50 and linear_velocity.abs().y < 50:
		queue_free()

func check_velocity():
	if linear_velocity.abs().x < 50 and linear_velocity.abs().y < 50:
		$KillTimer.start()
		stuck = true
	else:
		stuck = false
		$KillTimer.stop()

func _on_kill_timer_timeout():
	if stuck:
		queue_free()
