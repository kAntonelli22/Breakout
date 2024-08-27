extends CharacterBody2D

var win_size : Vector2
const START_SPEED = 500
const ACCEL = 20
var speed : int
var dir : Vector2
var score : int = 0
const MAX_X_VECTOR : float = 0.6

# difficulty variables
var hits : int = 0
var third_row_hit : bool = false
var fourth_row_hit : bool = false
var top_hit : bool = false

func _ready():
	win_size = get_viewport_rect().size

func new_ball():
	position.x = win_size.x / 2
	position.y = win_size.y / 1.5
	speed = START_SPEED
	hits = 0
	# increase speed if third or fourth row have already been hit
	if third_row_hit:
		speed += ACCEL
	if fourth_row_hit:
		speed += ACCEL
	dir = random_direction()
	
func _physics_process(delta):
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		if collider == $"../Player":
			# get new direction if ball collided with player paddle
			$"../WallImpactPlayer".play()
			dir = new_direction(collider)
		elif !top_hit and collider == $"../TopBound":
			# shrink paddle if ball collided with top bound for the first time
			$"../WallImpactPlayer".play()
			$"../Player".resize_player()
			top_hit = true
		elif collider.is_in_group("bricks"):
			# destroy brick and call brick_hit
			dir = dir.bounce(collision.get_normal())
			collider.queue_free()
			brick_hit(collider)
		else:
			# play impact sound and bounce ball
			$"../WallImpactPlayer".play()
			dir = dir.bounce(collision.get_normal())
	
func random_direction():
	var new_dir := Vector2()
	new_dir.x = randf_range(-1, 1)
	new_dir.y = -1
	return new_dir.normalized()
	
func new_direction(collider):
	var ball_x = position.x
	var pad_x = collider.position.x
	var dist = ball_x - pad_x
	var new_dir := Vector2()
	
	new_dir.y = -1
	new_dir.x = (dist / (collider.p_width / 2)) * MAX_X_VECTOR
	return new_dir.normalized()

func brick_hit(collider):
	$"../BrickImpactPlayer".play()
	# decrease brick count and check if screen is clear
	$"..".brick_count -= 1
	if $"..".brick_count <= 0:
		$"..".bricks_cleared()
	# handle ball acceleration for hit counter
	hits += 1
	if hits == 4:
		speed += ACCEL
	elif hits == 12:
		speed += ACCEL
	
	# give points based off of brick color
	if collider.color == Color(1, 1, 0):
		score += 1
	elif collider.color == Color(0, 1, 0):
		score += 3
	elif collider.color == Color(1, 0.5, 0):
		score += 5
		# increase speed if this is the first third row brick hit
		if !third_row_hit:
			speed += ACCEL
			third_row_hit = true
	elif collider.color == Color(1, 0, 0):
		score += 7
		# increase speed if this is the first third row brick hit
		if !fourth_row_hit:
			speed += ACCEL
			fourth_row_hit = true
	# update score counter
	$"../User Interface/Score".text = str(score) + " score"

func respawn_ball():
	process_mode = Node.PROCESS_MODE_DISABLED
	$"../ReloadScreen".start()
	

func _on_reload_screen_timeout():
	process_mode = Node.PROCESS_MODE_INHERIT
