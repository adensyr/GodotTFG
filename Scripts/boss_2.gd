extends CharacterBody2D

@onready var aniSprite:= $AnimatedSprite2D
@onready var balasEsp:= load("res://Scenes/Weapons/Bala.tscn")

var player = null
var detected = true
var PVs := 1.0
var inmune := false
var poisoned:= false
var p_time:= 0.0
var froze:= false
var f_time:= 0.0
var p_tick = 0.0
var hurt:= false
var dead:= false
var cooldown:= false
var ataque:= false
var especial:= false
var left:=true
var rng
var tp
var tpLeft
var tpRight
var bulletSpawn
var rounds:= 3
var ataques:= 0
var aimSpeed:= 6
var aim:= Vector2.RIGHT

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	rng = get_parent().get_parent().get_parent().rng
	tp = get_parent().get_parent().get_node("MarkerUp")
	tpRight = get_parent().get_parent().get_node("MarkerDown")
	tpLeft = get_parent().get_parent().get_node("MarkerDown2")
	bulletSpawn = get_parent().get_parent().get_node("MarkerBullet")
	await get_tree().create_timer(1).timeout
	ataque = true
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not dead: 
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
				
		if not froze:
			if ataque and not cooldown:
				atacar()
				cooldown = true
				await get_tree().create_timer(0.75).timeout
				cooldown = false
				if ataques == rounds:
					ataque = false
					teleport()
			elif especial:
				var playerAim = bulletSpawn.global_position.direction_to(player.global_position)
				aim = aim.lerp(playerAim, aimSpeed * delta).normalized()
	
	move_and_slide()

func poison(delta):
	p_tick+=delta
	if p_tick >= 0.47:
		p_tick = 0
		PVs-=0.5
		if PVs <= 0:
			queue_free()

func teleport():
	aniSprite.play("Teleport")
	await get_tree().create_timer(5).timeout
	var i = rng.randi_range(0,1)
	if i == 1:
		left = false
		global_position = tpLeft.global_position
	else:
		left = true
		global_position = tpRight.global_position
	aniSprite.play("Teleport down")
	especial = false
	ataque = true
	ataques = 0
	rounds = rng.randi_range(2, 5)

func ataque_especial():
	while especial:
		var bala = balasEsp.instantiate()
		bala.global_position = bulletSpawn.global_position
		bala.direction = aim
		bala.rotation = aim.angle()
		bala.remove_from_group("P_Attack")
		bala.add_to_group("hurt")
		bala.lifeTime = 10
		get_tree().current_scene.add_child(bala)
		
		await get_tree().create_timer(0.1).timeout

func atacar():
	ataques+=1
	aniSprite.flip_h = left
	aniSprite.play("Start attack")
	await get_tree().create_timer(0.3).timeout
	if not dead:
		aniSprite.play("End attack")
		var balaMalaScene = preload("res://Scenes/bala_mala.tscn")
		var balaMala = balaMalaScene.instantiate()
		if left:
			balaMala.global_position = $MarkerLeft.global_position
			balaMala.direction = Vector2.LEFT
			balaMala.get_node("Sprite2D").flip_h = true
		else:
			balaMala.global_position = $MarkerRight.global_position
		get_tree().current_scene.add_child(balaMala)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if not inmune and area.is_in_group("P_Attack"):
		get_hit(area)

func get_hit(area: Area2D):
	var damage = area.damage
	PVs -= damage
	if PVs <= 0:
		dead = true
		aniSprite.play("Die")
		get_node("Hitbox").queue_free()
	else:
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

func _on_animated_sprite_2d_animation_finished() -> void:
	if aniSprite.animation == "Teleport":
		global_position = tp.global_position
		especial = true
		ataque_especial()
		
	if aniSprite.animation == "Die":
		process_mode = Node.PROCESS_MODE_DISABLED
		get_node("CollisionShape2D").queue_free()
