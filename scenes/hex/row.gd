extends Node2D

@onready var hexes: Array = get_children()

var current_marker_position: int
signal play_pop()

func _ready():
	current_marker_position = 0
	for child in hexes:
		var num = round(randf_range(0,1))
		if num == 0:
			child.queue_free()
		else:
			child.connect("play_pop", _on_play_pop)
	set_health()

func _on_play_pop():
	play_pop.emit()

func is_empty():
	return get_child_count() == 0
		
func set_health():
	var children = get_children()
	var total_health = int(len(children) * Globals.current_round)
	
	for i in total_health:
		var num = randi_range(0,len(children) - 1)
		children[num].set_health(children[num].health + 1)
