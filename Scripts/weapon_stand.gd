extends Area2D

@export var weaponList: Array[PackedScene]

var player_inside:= false
var rng:= RandomNumberGenerator.new()
var player
var weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.seed = get_parent().get_parent().seed_used
	
	var wpn_scene = weaponList.get(rng.randi_range(0, weaponList.size()-1))
	weapon = wpn_scene.instantiate()
	get_node("Weapon").texture = weapon.get_node("Sprite2D").texture

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = false

func _input(event: InputEvent) -> void:
	if player_inside and weapon != null and event.is_action_pressed("interact"):
		player.get_wpn(weapon)
		get_node("Weapon").queue_free()
