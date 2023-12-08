extends StaticBody2D

@export var health: int = 1

signal update_score()
signal play_pop()

func _ready():
	var color1 = randf_range(0,1)
	var color2 = randf_range(0,1)
	var color3 = randf_range(0,1)
	while(color1 + color2 + color3 < 1):
		color1 = randf_range(0,1)
		color2 = randf_range(0,1)
		color3 = randf_range(0,1)
	$HexImage.modulate = Color(color1,color2,color3,1)
	
	#var index = randi_range(0, len(Globals.selected_colors) - 1)
	#$HexImage.modulate = Globals.selected_colors[index]
	#$PointLight2D.set_color($HexImage.modulate) 
	$Label.modulate = $HexImage.modulate
	
func _physics_process(_delta):
	if health <= 0:
		play_pop.emit()
		queue_free()
	
func set_health(health2: int):
	health = health2
	$Label.set_text(str(health))
	$PointLight2D.energy = 1
	
func hit():
	var tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 1, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($PointLight2D, "energy", 2, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property($PointLight2D, "energy", 1, 0.05).set_trans(Tween.TRANS_SINE)
	$PointLight2D.energy = health
	health -= 1
	$Label.set_text(str(health))
	Globals.points += 1
	update_score.emit()
