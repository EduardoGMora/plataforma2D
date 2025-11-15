extends Node2D

func _on_body_entered(body):
	# Verificar si es el jugador Y si ha recogido las 5 monedas
	if body.is_in_group("player"):
				
		# O si lo manejas desde el jugador
		if body.coins_collected >= 5:
			print("¡Ganaste el juego!")
				# Lógica de victoria (pantalla, cambio de escena, etc.)
		else:
			print("¡Necesitas ", 5 - body.coins_collected, " monedas más!")
