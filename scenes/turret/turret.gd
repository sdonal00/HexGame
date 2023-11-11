extends Node2D

signal create_projectiles(projectile: StaticBody2D)

var projectile_scene: PackedScene = preload("res://scenes/projectile/projectile.tscn")
var projectile_count: int = 1
var shooting: bool = false
var direction: Vector2

func _process(_delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("primary") and !shooting:
		position = get_global_mouse_position()
		visible = true
	elif Input.is_action_pressed("primary") and !shooting:
		var dir = (position - get_global_mouse_position()).normalized()
		rotation = dir.angle()
		direction = dir
		visible = true
	elif Input.is_action_just_released("primary") and !shooting:
		shooting = true
		var released_position = get_global_mouse_position()
		for i in projectile_count:
			var projectile = projectile_scene.instantiate()
			projectile.position = position
			projectile.direction = direction
			print(position.distance_to(released_position))
			projectile.speed = min(max(position.distance_to(released_position), 200), 600)
			create_projectiles.emit(projectile)
			await get_tree().create_timer(0.1).timeout
		shooting = false
		projectile_count += 1
	elif !shooting:
		visible = false
