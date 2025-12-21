extends Marker2D

@onready var Enemy = load("res://Scenes/enemy.tscn")
var spawned := false

func spawn(body):
	if not spawned and body.name == "Player":
		spawned = true
		var enemy_instance = null
		if get_parent().name == "Boss1":
			enemy_instance = Enemy.instantiate() #cambiar enemy por boss 1
			print("boss1")
		elif get_parent().name == "Boss2":
			enemy_instance = Enemy.instantiate() #cambiar enemy por boss 2
			print("boss2")
		else:
			enemy_instance = Enemy.instantiate()
		call_deferred("add_child", enemy_instance)

func _on_camera_area_body_entered(body: Node2D) -> void:
	spawn(body)
