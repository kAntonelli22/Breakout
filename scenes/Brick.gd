extends StaticBody2D

var color : Color
# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
