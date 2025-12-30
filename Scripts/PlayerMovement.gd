extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -550.0

@onready var ani = $Sprite2D/AnimationPlayer

var PVs := 4.0
var inmune := false
var defended:= false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_text_submit"):
		ani.play("Attack")
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if not inmune and body.is_in_group("hurt"):
		get_hit()

func new_item(item):
	var itemBag = get_node("ItemBag")
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

func get_hit():
	inmune = true
	var life_array = get_parent().get_node("UI/ColorRectL/VBoxContainer").get_children()
	if defended:
		if PVs == 0.5:
			die()
		else:
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
			life_array[PVs-1].get_node("AnimationPlayer").play("UIAnimations/LosePV")
			PVs -= 1
			await get_tree().create_timer(2).timeout
			inmune = false

func die():
	velocity = Vector2(0,0)
	call_deferred("get_tree.change_scene_to_file", "res://Scenes/death_panel.tscn")
