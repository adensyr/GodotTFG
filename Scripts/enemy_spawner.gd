extends Area2D

@onready var Enemy = load("res://Scenes/enemy.tscn")
var spawned := false

func spawn(body):
	if not spawned and body.name == "Player":
		spawned = true
		var enemy_instance = Enemy.instantiate()
		call_deferred("add_child", enemy_instance)

func _on_camera_area_body_entered(body: Node2D) -> void:
	spawn(body)
