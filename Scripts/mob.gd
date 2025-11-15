extends CharacterBody2D
var health = 1
@onready var animated_sprite = $AnimatedSprite2D
@export var gravity = 980.0
var direction = 0
var SPEED = 150.0

func take_damage(amount):
	health -= amount
	print("Enemigo golpeado. Vida restante: ", health)

	if health <= 0:
		die()
		
func die():
	# Lógica de muerte (animación, sonido, partículas, etc.)
	print("Enemigo ha muerto.")
	$AnimatedSprite2D.play("die")
	queue_free()
	
func _physics_process(delta):
	var velocity = get_velocity()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if (direction == -1 and $RayCastLeft.is_colliding()) or \
	   (direction == 1 and $RayCastRight.is_colliding()):
		direction *= -1 # Cambia de dirección
	
	# Mover
	velocity.x = direction * SPEED
	$AnimatedSprite2D.flip_h = (direction != 1)
	$AnimatedSprite2D.play("walk")
		
	move_and_slide()


func _on_hitbox_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.receive_damage(1)
