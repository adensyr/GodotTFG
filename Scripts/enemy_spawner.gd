extends Marker2D

@onready var Enemy = load("res://Scenes/enemy.tscn")
var spawned := false

func choose_spawn(enemy_count):
	spawned = true
	if enemy_count == 0:
		spawn()
	else:
		if (get_parent().get_parent().rng.randi() % 2) == 0:
			spawn()
	get_parent().enemy_count+=1

func spawn():
	var enemy_instance = null
	if get_parent().name == "Boss1":
		var Boss1 = load("res://Scenes/Boss1.tscn")
		enemy_instance = Boss1.instantiate()
	elif get_parent().name == "Boss2":
		var Boss2 = load("res://Scenes/Boss2.tscn")
		enemy_instance = Boss2.instantiate()
		print("boss2")
	else:
		enemy_instance = Enemy.instantiate()
	call_deferred("add_child", enemy_instance)

func _on_camera_area_body_entered(body: Node2D) -> void:
	if not spawned and body.name == "Player":
		choose_spawn(get_parent().enemy_count)
