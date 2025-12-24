extends Marker2D

@onready var Enemy = load("res://Scenes/enemy.tscn")
var spawned := false

func choose_spawn(body, enemy_count):
	if not spawned and body.name == "Player":
		if enemy_count == 0:
			spawn()
		else:
			if (get_parent().get_parent().rng.randi() % 2) == 0:
				spawn()
		get_parent().enemy_count+=1

func spawn():
	spawned = true
	var enemy_instance = null
	if get_parent().name == "Boss1":
		enemy_instance = Enemy.instantiate() #cambiar enemy por boss 1
		enemy_instance.add_to_group("boss")
		print("boss1")
	elif get_parent().name == "Boss2":
		enemy_instance = Enemy.instantiate() #cambiar enemy por boss 2
		print("boss2")
	else:
		enemy_instance = Enemy.instantiate()
	call_deferred("add_child", enemy_instance)

func _on_camera_area_body_entered(body: Node2D) -> void:
	choose_spawn(body, get_parent().enemy_count)
