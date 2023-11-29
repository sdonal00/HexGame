extends RigidBody2D

var speed: int
var direction: Vector2
var stuck: bool = false

signal hit_timer_reset()

func _ready():
	linear_velocity = direction * speed
	linear_damp = 0
	
func _physics_process(_delta):
	pass
	#todo: check if object is stuck in area (timer once no damage is done to hexes)

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

func _on_body_entered(body):
	if body.has_method("hit"):
		$HitSound.play()
		hit_timer_reset.emit()
		body.hit()
