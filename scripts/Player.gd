extends StaticBody2D

var win_width : int
var p_width : int
const PADDLE_SPEED : int = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	win_width = get_viewport_rect().size.x
	p_width = $ColorRect.get_size().x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += PADDLE_SPEED * delta
		
	# limit paddle movement to the window
	position.x = clamp(position.x, p_width / 2, win_width - p_width / 2)
	
func resize_player():
	var collisionShape := $CollisionShape2D
	var colorRect := $ColorRect
	
	var new_size := Vector2(collisionShape.shape.size.x / 2, collisionShape.shape.size.y)
	collisionShape.shape.set_size(new_size)
	
	colorRect.size.x /= 2
	colorRect.position.x += colorRect.size.x / 2
	p_width = $ColorRect.get_size().x
