extends enemy_melee

var playerLevel:= "Mid"
var level:= "Mid"
var charging:= false
var stun:= false
var jumping:= false
var topP
var midP
var botP

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	topP = get_parent().get_parent().get_node("MarkerTop")
	midP = get_parent().get_parent().get_node("MarkerMid")
	botP = get_parent().get_parent().get_node("MarkerBot")
	var top = get_parent().get_parent().get_node("Top")
	var mid = get_parent().get_parent().get_node("Mid")
	var bot = get_parent().get_parent().get_node("Bot")
	top.connect("body_entered", Callable(self, "_on_top_body_entered"))
	mid.connect("body_entered", Callable(self, "_on_mid_body_entered"))
	bot.connect("body_entered", Callable(self, "_on_bot_body_entered"))

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
		
		if level == playerLevel:
			if detected and not froze:
				var direction = global_position.direction_to(player.global_position).x
				velocity.x = direction * SPEED
				start_running(direction)
			elif not detected and not charging:
				velocity = Vector2(0,0)
				stop_running()
				charge()
			elif not detected and charging:
				if is_on_wall():
					stun = true
					aniSprite.play("Stun")
					await get_tree().create_timer(3).timeout
					stun = false
		else:
			if not jumping:
				jump_to_level()
		move_and_slide()
	elif atacando and not hurt and not dead and not cooldown and not froze:
			ani.play("Attack")
			aniSprite.play("Attack")
			cooldown = true
			await get_tree().create_timer(1.5).timeout
			cooldown = false

func charge():
	aniSprite.play("Charge")
	charging = true

func jump_to_level():
	jumping = true
	set_collision_mask_value(1, false)
	var start = global_position
	var jumpT = 0.8
	var g = get_gravity().y
	aniSprite.play("Jump")
	if playerLevel == "Top":
		var dx = topP.position.x - start.x
		var dy = topP.position.y - start.y
		
		velocity.x = dx / jumpT
		velocity.y = (dy - 0.5 * g* jumpT * jumpT) / jumpT
	elif playerLevel == "Mid":
		var dx = midP.position.x - start.x
		var dy = midP.position.y - start.y
		
		velocity.x = dx / jumpT
		velocity.y = (dy - 0.5 * g * jumpT * jumpT) / jumpT
	else: 
		var dx = botP.position.x - start.x
		var dy = botP.position.y - start.y
		
		velocity.x = dx / jumpT
		velocity.y = (dy - 0.5 * g * jumpT * jumpT) / jumpT
		
	level = playerLevel
	await get_tree().create_timer(jumpT-0.05).timeout
	jumping = false
	set_collision_mask_value(1, true)
	velocity.x = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	if aniSprite.animation == "Hurt":
		hurt = false
	
	if aniSprite.animation == "Start run":
		aniSprite.play("Run")
	
	if aniSprite.animation == "Die":
		process_mode = Node.PROCESS_MODE_DISABLED
	
	if aniSprite.animation == "Stun":
		if stun:
			aniSprite.play("Stun")

func _on_top_body_entered(body):
	if body.name == "Player":
		playerLevel = "Top"

func _on_mid_body_entered(body):
	if body.name == "Player":
		playerLevel = "Mid"

func _on_bot_body_entered(body):
	if body.name == "Player":
		playerLevel = "Bot"

func _on_hitbox_area_entered(area: Area2D) -> void:
	if not inmune and area.is_in_group("P_Attack"):
		get_hit(area)
