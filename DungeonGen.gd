extends Node2D

@export var rooms: Array[PackedScene]
@export var dead_ends: Array[PackedScene]
@export var max_rooms:= 10

var placed_rooms: Array = []
var total_rooms: Array = []
var current_rooms:= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	generate()

func generate():
	var start_room = rooms.pick_random().instantiate()
	add_child(start_room)
	start_room.position = Vector2.ZERO
	placed_rooms.append(start_room)
	
	while current_rooms < max_rooms:
		try_add_room(rooms)
	
	while not placed_rooms.is_empty():
		try_add_room(dead_ends)

func try_add_room(multi_rooms: Array):
	var base_room = placed_rooms.pick_random()
	var base_conections = base_room.get_node("Conexiones").get_children()
	
	if base_conections.is_empty():
		if current_rooms >= max_rooms:
			for r in range(placed_rooms.size()):
					if placed_rooms.get(r) == base_room:
						placed_rooms.remove_at(r)
						break
		return
	
	var base_conn = base_conections.pick_random()
	var dir = base_conn.name.to_lower()
	
	var new_room = multi_rooms.pick_random().instantiate()
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
