extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
@export var gravity = 980.0
@export var roll_speed_multiplier = 1.1
@onready var animated_sprite = $AnimatedSprite2D # Referencia a tu nodo AnimatedSprite2D
@onready var attack_hitbox = $Hitbox_Attack
var health = 3

# Variables de estado
var is_rolling = false
var is_attacking = false
var coins_collected = 0
const COINS_TO_WIN = 5

func _ready() -> void:
	pass

func _physics_process(delta):
	var velocity = get_velocity()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# 2. Lógica de Salto (InputMap)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 15) # Desaceleración
	
	if velocity.x > 0:
		animated_sprite.flip_h = false # Mira a la derecha
	elif velocity.x < 0:
		animated_sprite.flip_h = true  # Mira a la izquierda
		
	_update_animation(velocity)
	
	self.velocity = velocity
	move_and_slide()
	
func _update_animation(velocity):
	var animation_name = "idle"
	
	if not is_on_floor():
		animation_name = "jump"
	elif velocity.x != 0:
		animation_name = "walk"
		
	animated_sprite.play(animation_name)
	
func collect_coin():
	coins_collected += 1
	if coins_collected >= COINS_TO_WIN:
		win_game()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and !is_attacking:
		is_attacking = true
		attack()

func attack():
	animated_sprite.play("attack")
	attack_hitbox.monitoring = true
	
func take_damage(amount):
	health -= amount
	print("Jugador golpeado. Vida restante: ", health)

	if health <= 0:
		player_die()
	
func player_die():
	print("Has muerto")
	print("Game Over")
	animated_sprite.play("die")
	queue_free()
	
func _on_hitbox_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		body.take_damage(1)

func win_game():
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	
	if current_animation == "attack":
		is_attacking = false
