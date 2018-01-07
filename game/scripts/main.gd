extends Node2D
var initial_speed = 300
var canvas
var WHITE = Color(1,1,1)
var steps = 1000
var g = 9.8
var time_step = 1
var ballObj = load("res://objects/ball.tscn")
var velocity

func _ready():
	canvas = $canvas
	pass

func _input(event):
	if Input.is_action_pressed("fire"):
		var ball = ballObj.instance()
		ball.position = $gun.position
		ball.apply_impulse(Vector2(0,0), velocity)
		add_child(ball)

func _physics_process(delta):
	canvas.lines = []
	if Input.is_action_pressed("ui_left"):
		$gun.rotation -= 1 * delta
	elif Input.is_action_pressed("ui_right"):
		$gun.rotation += 1 * delta
	if Input.is_action_pressed("ui_up"):
		initial_speed += 0.1
		$gun.scale.x = initial_speed/10
	if Input.is_action_pressed("ui_down"):
		initial_speed -= 0.1
		$gun.scale.x = initial_speed/10
	var start = $gun.position
	var vec = Vector2(cos($gun.rotation),sin($gun.rotation)).normalized()
	var end = start + vec * initial_speed
	canvas.lines.append([start, end, WHITE])
	velocity = vec * initial_speed
	var time = 0
	start = Vector2()
	for i in range(steps):
		var x = (velocity.length() * time * -velocity.normalized().x) * 0.1 
		var y = (velocity.length() * time * -velocity.normalized().y - 0.5 * g * time*time) * 0.1 
		time += time_step
		var pos = Vector2(-x,-y)
		canvas.lines.append([start + $gun.position, pos + $gun.position, WHITE])
		start = pos
	canvas.update()