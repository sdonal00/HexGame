extends Node2D

signal create_projectiles(projectile: StaticBody2D)

var projectile_scene: PackedScene = preload("res://scenes/projectile/projectile.tscn")
var line_scene: PackedScene = preload("res://scenes/turret/line.tscn")

var projectile_count: int = 1
var shooting: bool = false
var direction: Vector2
var lines: Array
var max_lines: int = 6

func _process(_delta):
	get_input()

func spawn_lines():
	var distance = int(position.distance_to(get_global_mouse_position()) / 60)
	var line_count = $Lines.get_child_count()
	
	if distance < line_count:
		for i in line_count - distance:
			var line = lines.pop_back()
			line.queue_free()
		
	elif distance > line_count:
		var total_line_count = line_count
		for i in distance - line_count:
			if total_line_count <= 6:
				var line = line_scene.instantiate()
				line.position = $Marker2D.position * (i + line_count + 1)
				lines.append(line)
				$Lines.add_child(line)
				total_line_count += 1
				
func get_input():
	if Input.is_action_just_pressed("primary") and !shooting:
		position = get_global_mouse_position()
		visible = true
	elif Input.is_action_pressed("primary") and !shooting:
		var dir = (position - get_global_mouse_position()).normalized()
		rotation = dir.angle()
		direction = dir
		spawn_lines()
		visible = true
	elif Input.is_action_just_released("primary") and !shooting:
		shooting = true
		var released_position = get_global_mouse_position()
		for i in projectile_count:
			var projectile = projectile_scene.instantiate()
			projectile.position = position
			projectile.direction = direction
			projectile.speed = min(max(position.distance_to(released_position), 200), 600)
			create_projectiles.emit(projectile)
			await get_tree().create_timer(0.1).timeout
		shooting = false
		projectile_count += 1
	elif !shooting:
		var lines = $Lines.get_children()
		for child in lines:
			child.queue_free()
		visible = false
