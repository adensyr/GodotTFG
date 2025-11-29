extends Camera2D

@export var speed := 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	if Input.is_action_just_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_just_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_just_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_just_pressed("ui_up"):
		input_vector.y -= 1
	
	if input_vector != Vector2.ZERO:
		position += input_vector.normalized() * speed * delta
