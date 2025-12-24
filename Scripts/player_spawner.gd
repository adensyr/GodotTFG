extends Marker2D

@onready var Player = load("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn()

func spawn() -> void:
	var player = get_parent().get_parent().get_node("Player")
	player.position = self.position
