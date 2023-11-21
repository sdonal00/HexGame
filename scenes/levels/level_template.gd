extends Node2D

var row_scene: PackedScene = preload("res://scenes/hex/row.tscn")
@onready var row_markers: Array = $RowMarkers.get_children()

signal all_hexes_killed()
signal update_score()
signal projectile_deleted()
signal game_over()

func _ready():
	create_row()
	move_rows()
	
func start_next_round():
	if !Globals.game_over:
		Globals.current_round += 1
		call_deferred("create_row")
		call_deferred("move_rows")

func move_rows():
	var rows = $Rows.get_children()
	for i in len(rows):
		if i < len(row_markers) - 1 and i < len(rows) and len(row_markers) > len(rows)-i:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(rows[i], "position", row_markers[len(rows)-i].position, 1).set_trans(Tween.TRANS_SINE)
		else:
			if rows[0].is_empty():
				rows[0].queue_free()
			else:
				$Rows.get_child($Rows.get_child_count() - 1).queue_free()
				Globals.game_over = true
				print("game over")
				reverse_rows()

func reverse_rows():
	Globals.game_over = false
	var rows = $Rows.get_children()
	for i in len(rows):
		if i < len(row_markers) - 1 and i < len(rows) and len(row_markers) >= len(rows)-i:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(rows[i], "position", row_markers[len(rows) - i - 1].position, 1).set_trans(Tween.TRANS_SINE)
	
func create_row():
	var scene = row_scene.instantiate()
	$Rows.add_child(scene)
	scene.connect("play_pop", _on_play_pop)
	connect_hex_signal()
	
func _on_play_pop():
	$PopSound.play()
	
func connect_hex_signal():
	var hexes = get_tree().get_nodes_in_group("Hex")  
	for hex in hexes:  
		if !hex.is_connected("update_score", _on_update_score):
			hex.connect("update_score", _on_update_score)
			
func _on_update_score():
	update_score.emit()

func _on_shooting_zone_mouse_entered():
	Globals.mouse_in_shooting_zone = true

func _on_shooting_zone_mouse_exited():
	Globals.mouse_in_shooting_zone = false
	
func _on_despawn_zone_body_entered(body):
	if body.is_in_group("Projectile"):
		projectile_deleted.emit()
	body.queue_free()
