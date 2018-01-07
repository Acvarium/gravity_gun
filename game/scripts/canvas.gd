extends Node2D
var lines = []

func _ready():
	pass

func _draw():
	if lines.size() > 0:
		for l in lines:
			draw_line(l[0], l[1], l[2], 1.0)
