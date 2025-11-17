extends Area2D

func _ready() -> void:
	# Set collision layers properly: be a sensor that only detects player
	collision_layer = 0
	collision_mask = 1  # Detect player (layer 1)
	if has_node("CoinSprite"):
		$CoinSprite.play("idle")

func _process(delta: float) -> void:
	if has_node("CoinSprite"):
		$CoinSprite.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Increment on player, let HUD listen to player's signal
		body.collect_coin()
		# SFX if available
		if has_node("AudioStreamPlayer") and $AudioStreamPlayer.stream:
			$AudioStreamPlayer.play()
		# Visual feedback
		if has_node("CoinSprite"):
			$CoinSprite.play("collected")
		if has_node("PickupParticles"):
			$PickupParticles.emitting = true
			if has_node("CollisionShape2D"):
				$CollisionShape2D.disabled = true
			if has_node("CoinSprite"):
				$CoinSprite.visible = false
		# Wait briefly then remove
		await get_tree().create_timer(0.4).timeout
		queue_free()
