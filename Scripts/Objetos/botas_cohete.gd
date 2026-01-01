extends GameObject

var saltos:= 0

func _process(_delta: float) -> void:
	#doble salto
	if held:
		if Input.is_action_just_pressed("ui_select") and not player.is_on_floor() and saltos <= 1:
			player.velocity.y = player.JUMP_VELOCITY
			saltos+=1
	
		if player.is_on_floor() and saltos > 0:
			saltos = 0
