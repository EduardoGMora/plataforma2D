extends Node2D

@onready var play_button: Button = $PlayButton
@onready var exit_button: Button = $ExitButton
@onready var title_label: RichTextLabel = $RichTextLabel
@onready var coin_label: Label = $CoinLabel
@onready var message_label: Label = $MessageLabel
@onready var hp_hearts: Node2D = $HP

var level_scene: PackedScene = preload("res://Scenes/level.tscn")
var level_instance: Node = null
var player_ref: Node = null
var camera_ref: Camera2D = null

func _ready() -> void:
	coin_label.visible = false
	message_label.visible = false
	hp_hearts.visible = false
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_play_pressed() -> void:
	# Hide menu UI
	title_label.visible = false
	play_button.visible = false
	exit_button.visible = false
	# Load level
	level_instance = level_scene.instantiate()
	get_parent().add_child(level_instance)
	# Try to locate the player and connect signals
	await get_tree().process_frame
	if level_instance.has_node("Player"):
		player_ref = level_instance.get_node("Player")
	else:
		# Fallback: search
		for node in level_instance.get_children():
			if node.is_in_group("player"):
				player_ref = node
				break
	if player_ref:
		coin_label.visible = true
		hp_hearts.visible = true
		_update_coin_text(player_ref.coins_collected, player_ref.COINS_TO_WIN)
		_update_hearts(player_ref.current_health)
		if player_ref.has_signal("coin_count_changed"):
			player_ref.coin_count_changed.connect(_on_player_coin_changed)
		if player_ref.has_signal("health_changed"):
			player_ref.health_changed.connect(_on_player_health_changed)
		if player_ref.has_signal("player_died"):
			player_ref.player_died.connect(_on_player_died)
		if player_ref.has_signal("victory"):
			player_ref.victory.connect(_on_victory)
		# Find camera
		if player_ref.has_node("Camera2D"):
			camera_ref = player_ref.get_node("Camera2D")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_player_coin_changed(count: int) -> void:
	var target = 10
	if player_ref and "COINS_TO_WIN" in player_ref:
		target = player_ref.COINS_TO_WIN
	_update_coin_text(count, target)

func _process(_delta: float) -> void:
	if camera_ref and player_ref:
		# Position labels relative to camera
		var cam_pos = camera_ref.get_screen_center_position()
		var viewport_size = get_viewport().get_visible_rect().size
		coin_label.global_position = cam_pos - viewport_size / 2 + Vector2(16, 16)
		hp_hearts.global_position = cam_pos - viewport_size / 2 + Vector2(30, 70)
		message_label.global_position = cam_pos - viewport_size / 2 + Vector2(420, 24)

func _update_coin_text(count: int, target: int) -> void:
	coin_label.text = "Coins: %d / %d" % [count, target]

func _update_hearts(health: int) -> void:
	if hp_hearts.has_node("heart1"):
		hp_hearts.get_node("heart1").visible = (health >= 1)
	if hp_hearts.has_node("heart2"):
		hp_hearts.get_node("heart2").visible = (health >= 2)
	if hp_hearts.has_node("heart3"):
		hp_hearts.get_node("heart3").visible = (health >= 3)

func _on_player_health_changed(current: int, _maximum: int) -> void:
	_update_hearts(current)

func _on_player_died() -> void:
	_show_message("Bummer! Try again.")

func _on_victory() -> void:
	await _show_message("You win! Nicely done.", 1.2)
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()

func _show_message(text: String, duration: float = 1.0) -> void:
	message_label.text = text
	message_label.visible = true
	await get_tree().create_timer(duration).timeout
	message_label.visible = false
