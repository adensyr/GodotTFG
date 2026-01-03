extends Area2D

var speed:= 300
var direction:= Vector2.RIGHT

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	await get_tree().create_timer(0.15).timeout
	direction = Vector2(0,0)
	await get_tree().create_timer(0.5).timeout
	direction = global_position.direction_to(player.global_position)
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position+= direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name in ["Walls", "Player"]:
		queue_free()
