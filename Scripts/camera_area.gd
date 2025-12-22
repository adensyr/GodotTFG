extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(get_node("/root/Mundo"), "_on_camera_area_body_entered").bind(self))
