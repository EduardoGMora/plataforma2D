extends Node2D

var coin_scene: PackedScene = preload("res://Scenes/coin.tscn")
var goal_scene: PackedScene = preload("res://Scenes/goal.tscn")
@export var auto_spawn_if_missing: bool = true
@export var auto_coin_count: int = 10
@export var coin_spacing: float = 96.0

func _ready() -> void:
    if not auto_spawn_if_missing:
        return
    _ensure_min_coins()
    _ensure_goal()

func _ensure_min_coins() -> void:
    var existing := get_tree().get_nodes_in_group("coins").size()
    if existing >= auto_coin_count:
        return
    var player: Node2D = get_node_or_null("Player")
    if not player:
        return
    var start_pos := player.global_position + Vector2(64, -100)
    var to_spawn := auto_coin_count - existing
    for i in range(to_spawn):
        var coin := coin_scene.instantiate()
        add_child(coin)
        coin.global_position = start_pos + Vector2(i * coin_spacing, 0)

func _ensure_goal() -> void:
    # Add a simple goal if none exists
    if _has_goal():
        return
    var player: Node2D = get_node_or_null("Player")
    if not player:
        return
    var goal := goal_scene.instantiate()
    add_child(goal)
    goal.position = player.position + Vector2(800, -32)

func _has_goal() -> bool:
    for child in get_children():
        if child is Node and child.has_method("_on_body_entered") and child.get_class() == "Area2D":
            return true
    return false
