extends attack

var speed:= 400
var direction:= Vector2.RIGHT
var lifeTime:= 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pistola = get_tree().get_first_node_in_group("player").get_node("WeaponSlot").get_child(0).get_node("Attack")
	damage = pistola.damage
	poisonous = pistola.poisonous
	poison_time = pistola.poison_time
	freezer = pistola.freezer
	freeze_time = pistola.freeze_time
	await get_tree().create_timer(lifeTime).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position+= direction * speed * delta

func _on_area_entered(area: Area2D):
	if area.name == "Hitbox":
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Walls":
		$AudioStreamPlayer2D.play()
		queue_free()
