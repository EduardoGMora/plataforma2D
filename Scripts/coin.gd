extends Area2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$CoinSprite.play("idle")

func _on_collectbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.collect_coin()
		$CoinSprite.play("collected")
		queue_free()
