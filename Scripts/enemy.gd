extends CharacterBody2D


const SPEED = 100.0

var player = null
var detected = false
var PVs := 2
var inmune := false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()  * delta
	else:
		if detected:
			velocity = position.direction_to(player.position) * SPEED
		else:
			velocity = Vector2(0,0)
	
	move_and_slide()

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		detected = true

func _on_detection_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		detected = false

func get_hit():
	PVs -= 1
	inmune = true
	await get_tree().create_timer(1.5).timeout
	inmune = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not inmune and area.is_in_group("P_Attack"):
		get_hit()
