extends Area2D

@export var lootable:= false

@onready var ani = $Sprite2D/AnimationPlayer

var broken:= false

func _on_area_entered(area: Area2D) -> void:
	if not broken and area.is_in_group("P_Attack"):
		ani.play("UIAnimations/LoseHalfPV2") #substituir por animacion de romper
		broken = true
		if lootable:
			throw_loot()

func throw_loot():
	pass
