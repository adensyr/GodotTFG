extends Marker2D

@export var left:= false

@onready var Enemy = load("res://Scenes/Enemy_Ranged.tscn")
var spawned := false

func spawn():
	var enemy_instance = Enemy.instantiate()
	enemy_instance.left = left
	call_deferred("add_child", enemy_instance)

func _on_camera_area_body_entered(body: Node2D) -> void:
	if not spawned and body.name == "Player":
		spawn()
