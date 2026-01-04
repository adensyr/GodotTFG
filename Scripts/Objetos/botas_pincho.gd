extends GameObject

func _ready() -> void:
	tooltip = "Ahora te agarras a las paredes"

func _process(_delta: float) -> void:
	if player.is_on_wall():
		player.velocity = Vector2(0,0)
		if Input.is_action_just_pressed("ui_select"):
			player.velocity.y = player.JUMP_VELOCITY
