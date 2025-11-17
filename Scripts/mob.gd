extends CharacterBody2D

var health = 3
var is_dead = false
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox_Attack/CollisionShape2D
@onready var hitbox_area = $Hitbox_Attack
@export var gravity = 980.0
var direction = -1
var SPEED = 100.0
var is_attacking = false
@export var detection_range = 150.0
@export var hitbox_offset = Vector2(-1, 2.33333)

func _ready():
	# Disable hitbox by default to prevent constant damage
	hitbox_area.monitoring = false

func take_damage(amount):
	if is_dead:
		return
		
	health -= amount
	print("Enemy hit. Health: ", health)
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)

	if health <= 0:
		die()
		
func die():
	is_dead = true
	print("Enemy defeated.")
	
	# Play death sound
	_play_sound(200.0, 0.25)
	
	# Disable collisions
	$CollisionShape2D.set_deferred("disabled", true)
	$Hitbox_Attack/CollisionShape2D.set_deferred("disabled", true)
	
	# Play death animation and fade out
	$AnimatedSprite2D.play("die")
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)
	
func _physics_process(delta):
	if is_dead or is_attacking:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Check for player nearby
	var player = _find_player_nearby()
	if player:
		# Face the player
		var player_dir = sign(player.global_position.x - global_position.x)
		if player_dir != 0:
			direction = player_dir
		
		# Trigger attack if player is very close and not already attacking
		var distance = global_position.distance_to(player.global_position)
		if distance <= 50 and not is_attacking:
			# Enable hitbox to trigger attack
			hitbox_area.monitoring = true
	else:
		# Normal patrol behavior
		if (direction == -1 and $RayCastLeft.is_colliding()) or \
		   (direction == 1 and $RayCastRight.is_colliding()):
			direction *= -1 # flip direction
	
	# Mover
	velocity.x = direction * SPEED
	$AnimatedSprite2D.flip_h = (direction != 1)
	
	# Flip hitbox position based on direction
	if direction == -1:
		hitbox.position.x = -abs(hitbox_offset.x)
	else:
		hitbox.position.x = abs(hitbox_offset.x)
	
	$AnimatedSprite2D.play("walk")
	move_and_slide()

func _find_player_nearby() -> Node:
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0]
		var distance = global_position.distance_to(player.global_position)
		if distance <= detection_range:
			return player
	return null


func _on_hitbox_attack_body_entered(body: Node2D) -> void:
	if is_dead or is_attacking:
		return
		
	if body.is_in_group("player"):
		is_attacking = true
		velocity.x = 0  # Stop movement during attack
		
		# Enable hitbox only during attack
		hitbox_area.monitoring = true
		
		# Play attack animation and sound
		if animated_sprite.sprite_frames.has_animation("attack"):
			animated_sprite.play("attack")
		_play_sound(320.0, 0.1)  # Attack swoosh sound
		
		# Wait for attack animation timing before applying damage
		await get_tree().create_timer(0.3).timeout
		
		# Apply damage only if player still in hitbox range
		var overlapping = hitbox_area.get_overlapping_bodies()
		for overlapping_body in overlapping:
			if overlapping_body.is_in_group("player") and overlapping_body.has_method("take_damage"):
				overlapping_body.take_damage(1)
				break
		
		# Disable hitbox immediately after damage
		hitbox_area.monitoring = false
		
		# Wait before allowing next attack
		get_tree().create_timer(0.7).timeout.connect(func(): 
			if not is_dead:
				is_attacking = false
		)

func _play_sound(freq: float, duration: float, vol_db: float = -8.0) -> void:
	var sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = 44100
	sfx_player.stream = gen
	sfx_player.volume_db = vol_db
	sfx_player.play()
	var pb := sfx_player.get_stream_playback() as AudioStreamGeneratorPlayback
	if pb == null:
		sfx_player.queue_free()
		return
	var frames: int = int(gen.mix_rate * duration)
	var phase: float = 0.0
	var inc: float = 2.0 * PI * freq / gen.mix_rate
	while frames > 0:
		var to_write: int = min(frames, 512)
		var buf := PackedVector2Array()
		buf.resize(to_write)
		for i in to_write:
			var sample := sin(phase) * 0.3
			phase += inc
			buf[i] = Vector2(sample, sample)
		pb.push_buffer(buf)
		frames -= to_write
	await get_tree().create_timer(duration).timeout
	sfx_player.queue_free()
