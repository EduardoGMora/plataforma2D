extends Area2D

func _on_body_entered(body: Node) -> void:
	if body is Node and body.is_in_group("player"):
		print("Flag reached. You win!")
		if body.has_signal("victory"):
			body.emit_signal("victory")
