extends Camera2D

@export var enable_smoothing: bool = true
@export var smoothing_speed: float = 5.0

func _ready() -> void:
	enabled = true
	position_smoothing_enabled = enable_smoothing
	position_smoothing_speed = smoothing_speed
