extends Area2D

func _ready() -> void:
	# Set collision layers properly
	collision_layer = 0
	collision_mask = 1  # Detect player (layer 1)

func _process(delta: float) -> void:
	$CoinSprite.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.collect_coin()
		$CoinSprite.play("collected")
		# Wait for animation then remove
		await get_tree().create_timer(0.3).timeout
		queue_free()
