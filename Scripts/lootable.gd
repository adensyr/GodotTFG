extends breakable

var money: int
var rng

func _ready() -> void:
	rng = get_parent().get_parent().rng
	var selectedTexture = lootables.get(rng.randi_range(0, lootables.size()-1))
	get_node("Sprite2D").set_texture(selectedTexture)
	
	if selectedTexture.resource_path == "res://textures/breakables/Lootables/Caja especial.png":
		money = 5
	else:
		money = rng.randi_range(1, 2)

func _on_area_entered(area: Area2D) -> void:
	if not broken and area.is_in_group("P_Attack"):
		var a = get_node("Sprite2D").get_texture().resource_path
		if a in ["res://textures/breakables/Lootables/Barriles.png", "res://textures/breakables/Lootables/Caja especial.png"]:
			ani.play("break(metal)")
		else:
			ani.play("break(wood)")
		broken = true
		for i in money:
			throw_loot()

func throw_loot():
	var monedaScene = preload("res://Scenes/monedas.tscn")
	var moneda = monedaScene.instantiate()
	call_deferred("add_child", moneda)
