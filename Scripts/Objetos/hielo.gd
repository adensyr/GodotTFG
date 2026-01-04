extends GameObject

func _ready() -> void:
	tooltip = "Los dejarás congelados"

func get_extra_effect():
	var weapon = player.get_node("WeaponSlot").get_child(0).get_node("Attack")
	weapon.change_stats(0, false, 0, true, 1, Color("76a8ffb4"))
