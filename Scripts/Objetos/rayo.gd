extends GameObject

func get_extra_effect():
	#0.5s de pausa
	player.get_node("Attack").change_stats(0.5, false, 0, true, 0.5)
