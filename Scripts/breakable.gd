extends Area2D
class_name breakable

@export var breakables: Array[Texture2D]
@export var lootables: Array[Texture2D]

@onready var ani = $Sprite2D/AnimationPlayer

var broken:= false

func _ready() -> void:
	var mundo = get_parent().get_parent()
	var selectedTexture
	selectedTexture = breakables.get(mundo.rng.randi_range(0, breakables.size()-1))
	get_node("Sprite2D").set_texture(selectedTexture)

func _on_area_entered(area: Area2D) -> void:
	if not broken and area.is_in_group("P_Attack"):
		var a = get_node("Sprite2D").get_texture().resource_path
		if a == "res://textures/breakables/Lootables/Barriles.png":
			ani.play("break(metal)")
		else:
			ani.play("break(wood)")
		broken = true
