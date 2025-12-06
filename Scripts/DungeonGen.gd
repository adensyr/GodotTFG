extends Node2D

@export var initial_room: PackedScene
@export var rooms: Array[PackedScene]
@export var dead_ends: Array[PackedScene]
@export var max_rooms: int

var placed_rooms: Array = []
var total_rooms: Array = []
var current_rooms:= 1
var rng:= RandomNumberGenerator.new()
var seed_used

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if seed_used == null:
		seed_used = randi()
	rng.seed = seed_used
	get_node("PauseMenu/ColorRect/LineEdit").set_text(str(seed_used))
	generate()

func generate():
	var start_room = initial_room.instantiate()
	add_child(start_room)
	start_room.position = Vector2.ZERO
	placed_rooms.append(start_room)
	total_rooms.append(start_room)
	
	while current_rooms < max_rooms:
		try_add_room(rooms)
	
	while not placed_rooms.is_empty():
		try_add_room(dead_ends)

func try_add_room(multi_rooms: Array):
	var base_room = placed_rooms.get(rng.randi_range(0, placed_rooms.size()-1))
	var base_conections = base_room.get_node("Conexiones").get_children()
	
	if base_conections.is_empty():
		if current_rooms >= max_rooms:
			for r in range(placed_rooms.size()):
					if placed_rooms.get(r) == base_room:
						placed_rooms.remove_at(r)
						break
		return
	
	var base_conn = base_conections.get(rng.randi_range(0, base_conections.size()-1))
	var dir = base_conn.name.to_lower()
	
	var new_room = multi_rooms.get(rng.randi_range(0, multi_rooms.size()-1)).instantiate()
	var new_connections = new_room.get_node("Conexiones").get_children()
	
	var opposite_name = get_opposite(dir)
	add_child(new_room)
		
	var target_conn = null
	for conn in new_connections:
		if conn.name.to_lower() == opposite_name:
			target_conn = conn
			break
	
	if target_conn == null:
		new_room.queue_free()
		return
	
	var offset = base_conn.global_position - target_conn.position
	new_room.global_position = offset
	
	base_room.get_node("Conexiones/"+base_conn.name).free()
	new_room.get_node("Conexiones/"+target_conn.name).free()
	if not overlaps(new_room):
		if current_rooms < max_rooms:
			placed_rooms.append(new_room)
		current_rooms+=1
		total_rooms.append(new_room)
		var r_conn = base_room.get_node("Conexiones").get_children()
		if r_conn.is_empty():
			for r in range(placed_rooms.size()):
				if placed_rooms.get(r) == base_room:
					placed_rooms.remove_at(r)
					break
	else:
		new_room.queue_free()

func get_opposite(dir:String) -> String:
	match dir:
		"left": return "right"
		"right": return "left"
		"up": return "down"
		"down": return "up"
		_: return ""

func overlaps(room: Node2D) -> bool:
	var room_rect = Rect2(room.global_position, room.size)
	
	for r in total_rooms:
		var r_rect = Rect2(r.global_position, r.size)
		if room_rect.intersects(r_rect):
			return true
	return false

func _on_camera_area_body_entered(body, room):
	if body.name == "Player":
		var cam = get_viewport().get_camera_2d()
		cam.move(room)
