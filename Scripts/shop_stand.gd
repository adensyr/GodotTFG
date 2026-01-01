extends item_stand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite = get_node("Sprite2D")
	var shopTexture = preload("res://textures/items/Shop stand.png")
	sprite.texture = shopTexture


func _input(event: InputEvent) -> void:
	if player_inside and item != null and event.is_action_pressed("interact"):
		if player.dinero >= 5:
			print("comprado")
		else:
			print("tu ere pobre tu no tiene aifon")
