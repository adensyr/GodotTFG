extends CharacterBody2D

@export var left:= false

@onready var aniSprite:= $AnimatedSprite2D

var player = null
var detected = true
var PVs := 3.0
var inmune := false
var poisoned:= false
var p_time:= 0.0
var froze:= false #cuando añada los ataques debo tambien pararlos
var f_time:= 0.0
var p_tick = 0.0
var hurt:= false
var dead:= false
var cooldown:= false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	var cameraArea = get_parent().get_parent().get_node("CameraArea")
	cameraArea.connect("body_entered", Callable(self, "_on_camera_area_body_entered"))
	cameraArea.connect("body_exited", Callable(self, "_on_camera_area_body_exited"))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not hurt and not dead:
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
		
		if detected and not froze and not cooldown:
			var balaMalaScene = preload("res://Scenes/bala_mala.tscn")
			var balaMala = balaMalaScene.instantiate()
			if left:
				balaMala.global_position = $MarkerLeft.global_position
				balaMala.direction = Vector2.LEFT
				balaMala.get_node("Sprite2D").flip_h = true
			else:
				balaMala.global_position = $MarkerRight.global_position
			get_tree().current_scene.add_child(balaMala)
			
			cooldown = true
			await get_tree().create_timer(2).timeout
			cooldown = false

func poison(delta):
	p_tick+=delta
	if p_tick >= 0.47:
		p_tick = 0
		PVs-=0.5
		if PVs <= 0:
			queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if not inmune and area.is_in_group("P_Attack"):
		get_hit(area)

func get_hit(area: Area2D):
	var damage = area.damage
	PVs -= damage
	if PVs <= 0:
		dead = true
		get_node("Hitbox").queue_free()
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

func _on_camera_area_body_entered(body):
	if body.name == "Player":
		detected = true

func _on_camera_area_body_exited(body):
	if body.name == "Player":
		detected = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if aniSprite.animation == "Hurt":
		hurt = false
	
	if aniSprite.animation == "Die":
		process_mode = Node.PROCESS_MODE_DISABLED
