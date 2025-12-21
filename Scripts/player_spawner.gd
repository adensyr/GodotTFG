extends Marker2D

@onready var Player = load("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn()

func spawn() -> void:
	var player_instance = Player.instantiate()
	get_parent().get_parent().call_deferred("add_child", player_instance)
