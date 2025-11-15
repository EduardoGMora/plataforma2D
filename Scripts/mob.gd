extends CharacterBody2D

var health = 3
var is_dead = false
@onready var animated_sprite = $AnimatedSprite2D
@export var gravity = 980.0
var direction = -1
var SPEED = 100.0

func take_damage(amount):
	if is_dead:
		return
		
	health -= amount
	print("Enemigo golpeado. Vida restante: ", health)
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)

	if health <= 0:
		die()
		
func die():
	is_dead = true
	print("Enemigo ha muerto.")
	
	# Disable collisions
	$CollisionShape2D.set_deferred("disabled", true)
	$Hitbox_Attack/CollisionShape2D.set_deferred("disabled", true)
	
	# Play death animation and fade out
	$AnimatedSprite2D.play("die")
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)
	
func _physics_process(delta):
	if is_dead:
		return
		
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
	
	set_velocity(velocity)
	move_and_slide()


func _on_hitbox_attack_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	if body.is_in_group("player"):
		body.take_damage(1)
