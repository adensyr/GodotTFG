extends Node2D
class_name GameObject

var objetos:= []
var player

func _ready() -> void:
	player = get_parent().get_parent()

func actualizar_bolsa():
	objetos = get_parent().get_node("ItemBag").get_children()

func get_extra_effect():
	pass

func _process(_delta: float) -> void:
	pass
