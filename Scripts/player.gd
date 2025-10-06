extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const GRAVITY = 980.0
@export var roll_speed_multiplier = 1.1 # Por si decides añadirlo después
@onready var animated_sprite = $AnimatedSprite2D # Referencia a tu nodo AnimatedSprite2D

# Variables de estado
var is_rolling = false
var is_attacking = false
var _direction = 0.0
var diamonds_collected = 0

func _ready() -> void:
	pass

func _physics_process(delta):
	var velocity = self.velocity
	
	# 1. Aplicar la gravedad (física 2D)
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# 2. Lógica de Salto (InputMap)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# 3. Lógica de Movimiento Horizontal (InputMap)
	
	# Reiniciamos la dirección horizontal a 0 antes de chequear las entradas
	_direction = 0.0
	if Input.is_action_pressed("move_right"):
		_direction = 1.0
	elif Input.is_action_pressed("move_left"):
		# Usamos 'elif' para que si se presionan ambas, 'move_right' tenga prioridad
		_direction = -1.0
	
	# Asignamos la velocidad horizontal
	velocity.x = _direction * SPEED
	
	# 4. Control de Volteo (Flip)
	if velocity.x > 0:
		animated_sprite.flip_h = false # Mira a la derecha
	elif velocity.x < 0:
		animated_sprite.flip_h = true  # Mira a la izquierda
		
	# 5. Actualización de Animación
	_update_animation(velocity)
	
	# 6. Mover el cuerpo y gestionar colisiones
	self.velocity = velocity
	move_and_slide()
	
func _update_animation(velocity):
	var animation_name = "idle"
	
	if not is_on_floor():
		animation_name = "jump"
	elif velocity.x != 0:
		animation_name = "walk"
		
	animated_sprite.play(animation_name)
	
func collect_diamond():
	diamonds_collected += 1
	
