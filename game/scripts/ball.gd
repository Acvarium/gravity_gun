extends RigidBody2D
var pos = Vector2()
var main_node
var x_speed = 0

func _ready():
	
	main_node = get_node("/root/main")

func _physics_process(delta):
	var x = (position.x - pos.x) * delta
	var y = (position.y - pos.y) * delta
	var x_text = 'x_speed = ' + str(x)# +' '+ str(x_speed / x )
	
	main_node.get_node("ball_x_speed").text = x_text
	var y_text = 'y_speed = ' + str(y)
	main_node.get_node("ball_y_speed").text = str(y_text)
	pos = position
	x_speed = x
func _on_Timer_timeout():
	queue_free()
