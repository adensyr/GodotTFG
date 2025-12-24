extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -550.0

@onready var ani = $Sprite2D/AnimationPlayer

var PVs := 4
var inmune := false

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

func get_hit():
	PVs -= 1
	if PVs <= 0:
		velocity = Vector2(0,0)
		get_tree().change_scene_to_file("res://Scenes/death_panel.tscn")
	else:
		inmune = true
		var life_array = get_parent().get_node("UI/ColorRectL/VBoxContainer").get_children()
		life_array[PVs].get_node("AnimationPlayer").play("LosePV")
		await get_tree().create_timer(2).timeout
		inmune = false
