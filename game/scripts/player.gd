extends RigidBody2D
var max_speed = 20000
var max_rot_speed = 0.2
var main_node
var canvas
const GREEN = Color(0,1,0)
const WHITE = Color(1,1,1)

var speed = 0
var rotation_speed = 0
var dir = Vector2()
#var c_position = Vector2()
#var to = Vector2()
var rays_hit = [false,false,false,false]
var angles = [0,0,0,0]


func _ready():
	randomize()
	for r in $rays.get_children():
		r.add_exception(self)
	main_node = get_node('/root/main')
	canvas = get_node('/root/main/canvas')
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		if speed < max_speed:
			speed += 500
	elif Input.is_action_pressed("ui_down"):
		if speed > -max_speed:
			speed -= 500
	else:
		if speed > 0 or speed < 0:
			speed *= 0.9
	if abs(speed) < 20:
		speed = 0 	
	if Input.is_action_pressed("ui_left"):
		rotation_speed = -100
	elif Input.is_action_pressed("ui_right"):
		rotation_speed = 100
	else:
		rotation_speed = 0
	
	angular_velocity = rotation_speed * delta
	dir = Vector2(cos(rotation - PI/2),sin(rotation - PI/2)).normalized()
	linear_velocity = (dir * speed * delta)
	lazer()


func _process(delta):
	for i in range(rays_hit.size()):
		var d = get_node('Camera2D/CanvasLayer/dots/d' + str(i))
		if rays_hit[i]:
			d.show()
		else:
			d.hide()
	
func lazer():
	var rays_cound = $rays.get_child_count()
	var point = global_position
	var rot = global_rotation
#	rays_hit = [false,false,false,false]
	canvas.lines = []
	for i in range(rays_cound):
		var ray = get_node("rays/r" + str(i))
		ray.global_position = point
		ray.global_rotation = rot
		ray.force_raycast_update()
#		rays_hit[i] = ray.is_colliding()

		if ray.is_colliding():
			var from = ray.get_collision_point()
			canvas.lines.append([point, from, WHITE])
			var n = ray.get_collision_normal()
			var d = (point - ray.get_collision_point()).normalized()
#			var to = d - 2*(d * n) * n
			var to = d.reflect(n)
			canvas.lines.append([ray.get_collision_point(),ray.get_collision_point() + n * 20, GREEN])
			rot = atan2(to.x,-to.y)
			point = ray.get_collision_point() + to.normalized() * 2
#		else:
#			canvas.lines.append([point, point + Vector2(cos(rotation - PI/2),sin(rotation - PI/2)).normalized() * 1000])

	canvas.update()
func _on_Timer_timeout():
	lazer()
