extends GameObject

func _process(delta: float) -> void:
	#salto en la pared
	if player.is_on_wall():
		player.velocity = Vector2(0,0)
		if Input.is_action_just_pressed("ui_select"):
			player.velocity.y = player.JUMP_VELOCITY
