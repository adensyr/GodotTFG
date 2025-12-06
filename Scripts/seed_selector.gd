extends Control


func _on_no_seed_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mundo.tscn")


func _on_seed_pressed() -> void:
	var world_seed = get_node("HBoxContainer/Seed/SpinBox").value
	var escena = preload("res://Scenes/mundo.tscn")
	var mundo = escena.instantiate()
	mundo.seed_used = world_seed
	get_tree().root.add_child(mundo)
	get_tree().current_scene.queue_free()
	get_tree().current_scene=mundo
