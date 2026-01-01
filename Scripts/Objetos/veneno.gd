extends GameObject

func get_extra_effect():
	var weapon = player.get_node("WeaponSlot").get_child(0).get_node("Attack")
	weapon.change_stats(0, true, 1, false, 0)
