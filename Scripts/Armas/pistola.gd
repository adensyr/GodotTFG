extends attack

@export var balaScene: PackedScene

var disparando:= false
var salida

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = 0.5
	salida = get_parent().get_node("Marker2D")

func atacar():
	if not disparando:
		disparando = true
		var bala = balaScene.instantiate()
		bala.global_position = salida.global_position
		
		get_tree().current_scene.add_child(bala)
		
		await get_tree().create_timer(bala.lifeTime).timeout
		disparando = false
