extends Node2D

var win_size : Vector2
const BRICK_WIDTH : int = 40
const BRICK_HEIGHT : int = 15
var brick_count : int = 0
var balls : int = 3;
var ui_balls
var screens_cleared : int = 0
var colors := [Color(1, 0, 0), Color(1, 0.5, 0), Color(0, 1, 0), Color(1, 1, 0)]

var brick = preload("res://scenes/brick.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	win_size = get_viewport_rect().size
	ui_balls = [
	$"User Interface/RightUIContainer/BallContainer/Ball1",
	$"User Interface/RightUIContainer/BallContainer/Ball2",
	$"User Interface/RightUIContainer/BallContainer/Ball3"
	]
	create_bricks()

# create 8 rows of colored bricks
func create_bricks():
	for i in range(0, (win_size.x / BRICK_WIDTH) - 1):
		for j in range(6, 14):
			var instance = brick.instantiate()
			instance.position.x = (i * BRICK_WIDTH) + (i * 2)
			instance.position.y = (j * BRICK_HEIGHT) + (j * 2)
			instance.color = colors[(j / 2) - 3]
			brick_count += 1
			
			add_child(instance)

# end game if player has cleared 2 screens of bricks. else respawn ball and refill screen
func bricks_cleared():
	print(screens_cleared)
	screens_cleared += 1
	if screens_cleared >= 2:
		print("you win")
	else:
		balls += 1
		print("ui_balls", ui_balls)
		if ui_balls[2].hidden:
			print("ui_balls[2]")
			ui_balls[2].visible = !ui_balls[2].visible
		elif ui_balls[1].hidden:
			print("ui_balls[1]")
			ui_balls[2].visible = !ui_balls[1].visible
		elif ui_balls[0].hidden:
			print("ui_balls[0]")
			ui_balls[2].visible = !ui_balls[0].visible
		$Ball.new_ball()
		$Ball.respawn_ball()
		create_bricks()

func _on_ball_timer_timeout():
	$Ball.new_ball()

func _on_goal_body_entered(body):
	balls -= 1
	if balls == 2:
		ui_balls[0].hide()
	elif balls == 1:
		ui_balls[1].hide()
	elif balls == 0:
		ui_balls[2].hide()
	
	if balls >= 0:
		$BallTimer.start()
	else:
		$GameOver.show()

func _on_button_pressed():
	get_tree().reload_current_scene()
