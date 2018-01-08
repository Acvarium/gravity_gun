extends Node2D
var initial_speed = 300
const WHITE = Color(1,1,1)
const GREEN = Color(0,1,0)
const TRANSP = Color(0,0,0,0)

var steps = 1000 #Number of steps of drawind a paraboloid
var g = Vector2(0, 9.8)
var time_step = 0.1
var ballObj = load("res://objects/ball.tscn")
var velocity
var line_count = 0
var linear_damp = 0

func _ready():
	pass

func _input(event):
	if Input.is_action_pressed("fire"):
		var ball = ballObj.instance()
		ball.position = $gun.position
		ball.linear_damp = linear_damp
		ball.apply_impulse(Vector2(0,0), velocity)
		for b in $balls.get_children():
			ball.add_collision_exception_with(b)
		$balls.add_child(ball)

func _physics_process(delta):
	$canvas.lines = []
	if Input.is_action_pressed("x_up"):
		linear_damp += 0.01
		$damp.text = "linier_damp = " + str(linear_damp)
	elif Input.is_action_pressed("x_down"):
		linear_damp -= 0.01
		if linear_damp < 0:
			linear_damp = 0
		$damp.text = "linier_damp = " + str(linear_damp)
	
	if Input.is_action_pressed("ui_left"):
		$gun.rotation -= 1 * delta
	elif Input.is_action_pressed("ui_right"):
		$gun.rotation += 1 * delta
	if Input.is_action_pressed("ui_up"):
		initial_speed += 0.3
		$gun.scale.x = initial_speed/10
	if Input.is_action_pressed("ui_down"):
		initial_speed -= 0.3
		$gun.scale.x = initial_speed/10
	var start = $gun.position
	var vec = Vector2(cos($gun.rotation),sin($gun.rotation)).normalized()
	velocity = vec * initial_speed
	var end = start + velocity
	
#Draw initial vector
	$canvas.lines.append([start, end, GREEN]) 
	
#Reset time value for drawing
	var time = 0
	start = Vector2()
	line_count = 0
	var pos = Vector2()
	var v = velocity
	for i in range(steps):
		pos += v * time_step * 0.1
		v += g * time_step
		v *= 1/(1 + linear_damp * time_step/10)
		
#Draw dashed lines of a paraboloid
#--------------------------------------------
		var col = WHITE
		if line_count > 1:
			col = TRANSP
		if line_count > 2:
			line_count = 0
		$canvas.lines.append([start + $gun.position, pos + $gun.position, col])
		line_count += 1
		start = pos
	$canvas.update()