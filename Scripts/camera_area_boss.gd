extends Area2D

func _process(delta: float) -> void:
	var cam = get_viewport().get_camera_2d()
	cam.move(get_parent().get_parent().get_node("Player"))
