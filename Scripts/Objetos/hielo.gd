extends GameObject

func get_extra_effect():
	#1s de pausa
	player.get_node("Attack").change_stats(0, false, 0, true, 1)
