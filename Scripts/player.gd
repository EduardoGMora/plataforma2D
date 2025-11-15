extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const MAX_JUMPS = 2  # Allow double jump
@export var gravity = 980.0
@export var roll_speed_multiplier = 1.1
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_hitbox = $Hitbox_Attack/CollisionShape2D

# Health and damage
var max_health = 3
var current_health = 3
var is_invulnerable = false
var invulnerability_time = 1.0

# State variables
var is_rolling = false
var is_attacking = false
var jump_count = 0  # Track number of jumps
var coins_collected = 0
const COINS_TO_WIN = 5

func _ready() -> void:
	# Disable attack hitbox initially
	attack_hitbox.disabled = true
	current_health = max_health

func _physics_process(delta):
	if is_attacking:
		pass
		
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset jump count when on ground
		jump_count = 0
	
	# Double Jump - can jump up to MAX_JUMPS times
	if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 15)
	
	if velocity.x > 0:
		animated_sprite.flip_h = false
		attack_hitbox.position.x = abs(attack_hitbox.position.x)
	elif velocity.x < 0:
		animated_sprite.flip_h = true
		attack_hitbox.position.x = -abs(attack_hitbox.position.x)
		
	_update_animation()
	
	move_and_slide()
	
func _update_animation():	
	var animation_name = "idle"
	
	if not is_on_floor():
		animation_name = "jump"
	elif velocity.x != 0:
		animation_name = "walk"
		
	animated_sprite.play(animation_name)
	
func collect_coin():
	coins_collected += 1
	print("Monedas recolectadas: ", coins_collected, "/", COINS_TO_WIN)
	if coins_collected >= COINS_TO_WIN:
		win_game()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and !is_attacking and is_on_floor():
		is_attacking = true
		attack()

func attack():
	animated_sprite.play("attack")
	attack_hitbox.disabled = false
	await animated_sprite.animation_finished
	attack_hitbox.disabled = true
	is_attacking = false
	
func take_damage(amount):
	if is_invulnerable:
		return
		
	current_health -= amount
	print("Jugador golpeado. Vida restante: ", current_health)
	
	# Invulnerability frames
	is_invulnerable = true
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(animated_sprite, "modulate:a", 0.5, 0.2)
	tween.tween_property(animated_sprite, "modulate:a", 1.0, 0.2)
	
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false
	animated_sprite.modulate.a = 1.0

	if current_health <= 0:
		player_die()
	
func player_die():
	print("Has muerto")
	print("Game Over")
	animated_sprite.play("die")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	
func _on_hitbox_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs") and is_attacking:
		body.take_damage(1)

func win_game():
	print("¡Has ganado! Todas las monedas recolectadas")


func _on_animated_sprite_2d_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	
	if current_animation == "attack":
		is_attacking = false
		attack_hitbox.disabled = true
