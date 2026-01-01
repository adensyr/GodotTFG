extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -550.0

@onready var ani = $AnimatedSprite2D/AnimationPlayer
@onready var aniSprite:= $AnimatedSprite2D

var PVs := 4.0
var inmune := false
var defended:= false
var startedRun:= false
var isRun:= false
var inAir:= false
var hurt:= false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not hurt:
		if velocity.y > 20: 
			aniSprite.play("Fall")
		elif not aniSprite.animation == "Jump":
			inAir = false
		
		if velocity.y < 20 and velocity.x == 0 and not inAir:
			startedRun = false
			isRun = false
			aniSprite.play("Idle")
		
		if Input.is_action_just_pressed("ui_text_submit"):
			ani.play("Attack")
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_select") and is_on_floor():
			inAir = true
			aniSprite.play("Jump")

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			if is_on_floor() or velocity.y < 20:
				start_running(direction)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.x == 0 and not inAir and isRun:
					stop_running()
		
	move_and_slide()

func start_running(direction):
	aniSprite.flip_h = direction < 0
	
	if not startedRun:
		aniSprite.play("Start_run")
		startedRun = true
		isRun = false
	elif isRun and not inAir:
		aniSprite.play("Run")

func _on_animated_sprite_2d_animation_finished() -> void:
	if aniSprite.animation == "Start_run":
		isRun = true
		aniSprite.play("Run")
	
	if aniSprite.animation == "Jump":
		velocity.y = JUMP_VELOCITY
	
	if aniSprite.animation == "Die":
		get_tree().change_scene_to_file("res://Scenes/death_panel.tscn")
	
	if aniSprite.animation == "Hurt":
		hurt = false

func stop_running():
	aniSprite.play("Stop_run")
	startedRun = false
	isRun = false

func new_item(item):
	var itemBag = get_node("ItemBag")
	item.held = true
	item.actualizar_bolsa()
	itemBag.add_child(item)
	var itemUiBoxes = get_parent().get_node("UI/ColorRectR/HBoxContainer").get_children()
	var itemTexture = item.get_node("Sprite2D").texture
	var textureRect:= TextureRect.new()
	textureRect.set_expand_mode(4 as TextureRect.ExpandMode)
	textureRect.set_texture(itemTexture)
	if (itemBag.get_children().size() % 2) == 0:
		itemUiBoxes[0].add_child(textureRect)
	else:
		itemUiBoxes[1].add_child(textureRect)
	if item.name == "Botas":
		SPEED=350.0
		JUMP_VELOCITY=-570.0
	elif item.name == "Escudo":
		defended = true
	else:
		item.get_extra_effect()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if not inmune and body.is_in_group("hurt"):
		get_hit()

func get_hit():
	hurt = true
	inmune = true
	var life_array = get_parent().get_node("UI/ColorRectL/VBoxContainer").get_children()
	if defended:
		if PVs == 0.5:
			die()
		else:
			aniSprite.play("Hurt")
			var intPV = int(PVs+0.5)
			if PVs == int(PVs+0.5):
				life_array[intPV-1].get_node("AnimationPlayer").play("UIAnimations/LoseHalfPV")
			else:
				life_array[intPV-1].get_node("AnimationPlayer").play("UIAnimations/LoseHalfPV2")
			PVs -= 0.5
			await get_tree().create_timer(2).timeout
			inmune = false
	else:
		if PVs == 1:
			die()
		else:
			aniSprite.play("Hurt")
			life_array[PVs-1].get_node("AnimationPlayer").play("UIAnimations/LosePV")
			PVs -= 1
			await get_tree().create_timer(2).timeout
			inmune = false

func die():
	velocity = Vector2(0,0)
	aniSprite.play("Die")
