extends RigidBody2D

var pickeable:= false
var mundo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = get_parent().global_position
	mundo = get_parent().get_parent().get_parent()
	var direction = mundo.rng.randf_range(-1.0, 1.0)
	var fuerza = Vector2(direction * 100.0, -300)
	apply_impulse(fuerza)
	
	await get_tree().create_timer(0.5).timeout
	pickeable = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and pickeable:
		body.dinero+=1
		mundo.get_node("UI/ColorRectR/MoneyContainer/Label").set_text(str(body.dinero))
		queue_free()
