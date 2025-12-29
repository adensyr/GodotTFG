extends GameObject

func get_extra_effect():
	player.get_node("Attack").change_stats(0.5, true, 0.5, false, 0)
