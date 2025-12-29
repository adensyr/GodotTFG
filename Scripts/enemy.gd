extends CharacterBody2D


const SPEED = 100.0

var player = null
var detected = false
var PVs := 3.0
var inmune := false
var poisoned:= false
var p_time:= 0.0
var froze:= false #cuando añada los ataques debo tambien pararlos
var f_time:= 0.0
var p_tick = 0.0

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	if poisoned:
		p_time-=delta
		if p_time <= 0:
			poisoned = false
		else:
			poison(delta)
	if froze:
		f_time-=delta
		if f_time <= 0:
			froze = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()  * delta
	else:
		if detected and not froze:
			velocity = global_position.direction_to(player.global_position) * SPEED
		else:
			velocity = Vector2(0,0)
	
	move_and_slide()

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		detected = true

func _on_detection_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		detected = false

func get_hit(area: Area2D):
	var damage = area.damage
	PVs -= damage
	if PVs <= 0:
		queue_free()
	else:
		if area.poisonous:
			p_time+=area.poison_time
			poisoned = true
		if area.freezer:
			f_time+=area.freeze_time
			froze = true
		inmune = true
		await get_tree().create_timer(1.5).timeout
		inmune = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if not inmune and area.is_in_group("P_Attack"):
		get_hit(area)

func poison(delta):
	p_tick+=delta
	if p_tick >= 0.47:
		p_tick = 0
		PVs-=0.5
		if PVs <= 0:
			queue_free()
