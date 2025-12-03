extends CanvasLayer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		$ColorRect.visible = not $ColorRect.visible

func _on_play_pressed() -> void:
	get_tree().paused = not get_tree().paused
	$ColorRect.visible = not $ColorRect.visible

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_quit_menu_pressed() -> void:
	get_tree().paused = not get_tree().paused
	get_tree().change_scene_to_file("res://main_menu.tscn")
