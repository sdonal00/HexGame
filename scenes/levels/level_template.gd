extends Node2D

var row_scene: PackedScene = preload("res://scenes/hex/row.tscn")
@onready var row_markers: Array = $RowMarkers.get_children()

signal all_hexes_killed()
signal update_score()
signal projectile_deleted()

func _ready():
	create_row()
	move_rows()
	
func start_next_round():
	Globals.current_round += 1
	call_deferred("create_row")
	call_deferred("move_rows")

func move_rows():
	var rows = $Rows.get_children()
	await $Rows.get_children()
	print(len(rows))
	for i in len(row_markers) - 1:
		print(i ," i")
		print(len(rows)," length")
		if i < len(rows):
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(rows[len(rows) - (i + 1)], "position", row_markers[i + 1].position, 1).set_trans(Tween.TRANS_SINE)
		else:
			break
			
func create_row():
	var scene = row_scene.instantiate()
	$Rows.add_child(scene)
	connect_hex_signal()
	
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
