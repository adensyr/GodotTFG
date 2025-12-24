extends Area2D

var player_inside:= false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = false

func _input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		if get_parent().name == "Spawn_level":
			get_parent().get_parent().cross_door("boss")
		else:
			get_parent().get_parent().cross_door("next")


func _on_camera_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("boss"):
		visible = not visible
