extends Area2D

@export var items: Array

var player_inside:= false
var with_item:= true
var rng:= RandomNumberGenerator.new()
var player
var item

func _ready() -> void:
	rng.seed = get_parent().get_parent().seed_used
	var item_scene = items.get(rng.randi_range(0, items.size()-1))
	items.erase(item_scene)
	item = item_scene.instantiate()
	get_node("Item").texture = item.get_node("Sprite2D").texture

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = false

func _input(event: InputEvent) -> void:
	if player_inside and with_item and event.is_action_pressed("interact"):
		player.new_item(item)
		with_item = false
		get_node("Item").queue_free()
