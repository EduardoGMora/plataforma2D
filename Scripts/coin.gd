extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		emit_signal("collected")
		$AudioStreamPlayer.play()
		$AnimatedSprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		await $AudioStreamPlayer.finished
		queue_free()
