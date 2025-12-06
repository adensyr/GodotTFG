extends CanvasLayer

func _ready() -> void:
	pass
	#get_node("ColorRect/LineEdit").Text = get_parent().seed_used

func _physics_process(_delta: float) -> void:
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
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
