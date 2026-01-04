extends CharacterBody2D
class_name enemy_melee

@onready var aniSprite:= $AnimatedSprite2D
@onready var ani:= $Attack/AnimationPlayer

@export var PVs:= 3.0

const SPEED = 100.0

var player = null
var detected = false
var inmune := false
var poisoned:= false
var p_time:= 0.0
var froze:= false
var f_time:= 0.0
var p_tick = 0.0
var hurt:= false
var dead:= false
var startedRun:= false
var atacando:= false
var cooldown:= false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	if not hurt and not dead and not atacando:
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
		elif detected and not froze:
			var direction = global_position.direction_to(player.global_position).x
			velocity.x = direction * SPEED
			start_running(direction)
		elif not detected and startedRun:
			velocity = Vector2(0,0)
			stop_running()
		
		move_and_slide()
	elif atacando and not hurt and not dead and not cooldown and not froze:
			ani.play("Attack")
			aniSprite.play("Attack")
			cooldown = true
			await get_tree().create_timer(1.5).timeout
			cooldown = false

func start_running(direction):
	aniSprite.flip_h = direction < 0
	
	if not startedRun:
		aniSprite.play("Start run")
		startedRun = true
	else:
		aniSprite.play("Run")

func stop_running():
	aniSprite.play("Stop run")
	startedRun = false

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		detected = true

func _on_detection_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		detected = false

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var ataque = get_node("Attack/CollisionShape2D")
		if aniSprite.flip_h:
			ataque.position.x = -(abs(ataque.position.x))
		else:
			ataque.position.x = abs(ataque.position.x)
		atacando = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		atacando = false

func get_hit(area: Area2D):
	$AudioStreamPlayer2D.play()
	var damage = area.damage
	PVs -= damage
	if PVs <= 0:
		dead = true
		get_node("Hitbox").queue_free()
		get_node("CollisionShape2D").queue_free()
		aniSprite.play("Die")
	else:
		aniSprite.play("Hurt")
		hurt = true
		if area.poisonous:
			p_time+=area.poison_time
			modulate = area.color
			poisoned = true
		if area.freezer:
			f_time+=area.freeze_time
			modulate = area.color
			froze = true
		inmune = true
		await get_tree().create_timer(1).timeout
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

func _on_animated_sprite_2d_animation_finished() -> void:
	if aniSprite.animation == "Hurt":
		hurt = false
	
	if aniSprite.animation == "Start run":
		aniSprite.play("Run")
	
	if aniSprite.animation == "Die":
		process_mode = Node.PROCESS_MODE_DISABLED
