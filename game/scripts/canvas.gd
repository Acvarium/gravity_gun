extends Node2D
#Object that can be used for drawing lines on screen
#In order to do this, reset the values in lines array

#>>lines = []

#then add the data in format

#>>lines.append([start_position, end_position, color])

#After adding all the data, call

#>>update()

var lines = []

func _ready():
	pass

func _draw():
	if lines.size() > 0:
		for l in lines:
			draw_line(l[0], l[1], l[2], 1.0)
