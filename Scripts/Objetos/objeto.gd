extends Node2D
class_name GameObject

var objetos
var player
var held:= false

func actualizar_bolsa():
	objetos = player.get_node("ItemBag").get_children()

func get_extra_effect():
	pass

func _process(_delta: float) -> void:
	pass
