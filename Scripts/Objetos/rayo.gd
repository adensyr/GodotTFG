extends GameObject

func _ready() -> void:
	tooltip = "Extra de daño y los dejarás en shock"

func get_extra_effect():
	var weapon = player.get_node("WeaponSlot").get_child(0).get_node("Attack")
	weapon.change_stats(0.5, false, 0, true, 0.5, Color("a38dfef0"))
