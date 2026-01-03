extends CanvasLayer

@onready var a = $ColorRectR/MoneyContainer/TextureRect

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	print(event)
