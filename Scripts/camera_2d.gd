extends Camera2D

var velocity = 20

func _proccess(delta):
	if Input.is_action_pressed("ui_right"):
		position.x += velocity * delta
	if Input.is_action_pressed("ui_left"):
		position.x -= velocity * delta
