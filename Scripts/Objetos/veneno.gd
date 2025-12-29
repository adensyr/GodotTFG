extends GameObject

func get_extra_effect():
	#1s de veneno 2 ticks 1 PV
	player.get_node("Attack").change_stats(0, true, 1, false, 0)
