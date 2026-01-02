extends Camera2D

@export var transition_speed := 5.0
var target_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_pos = global_position

func move(room: Node2D):
	target_pos = room.global_position

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(target_pos, delta*transition_speed)
	
	#quitar cuando acabe el desarrollo
	if Input.is_action_just_pressed("Zoom-out"):
		zoom-=Vector2(0.2,0.2)
	if Input.is_action_just_pressed("Zoom-in"):
		zoom+=Vector2(0.2,0.2)
