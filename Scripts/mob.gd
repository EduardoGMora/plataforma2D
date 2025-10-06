extends CharacterBody2D

const SPEED = 100.0
const GRAVITY = 980.0

var direction = -1.0

@onready var animated_sprite = $AnimatedSprite2D
	
func _physics_process(delta):
	var velocity = self.velocity
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	if is_on_floor():
		# Voltear si toca una pared o un borde (usa los RayCast2D)
		if (direction == -1 and $RayCastLeft.is_colliding()) or \
		   (direction == 1 and $RayCastRight.is_colliding()):
			direction *= -1 # Cambia de dirección
		
		# Mover
		velocity.x = direction * SPEED
		# Control de Volteo (Flip visual)
		$AnimatedSprite2D.flip_h = (direction != 1)
		$AnimatedSprite2D.play("walk")
		
	self.velocity = velocity
	move_and_slide()
