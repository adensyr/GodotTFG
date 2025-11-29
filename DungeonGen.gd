extends Node2D

@export var rooms: Array[PackedScene]
@export var max_rooms:= 10

var placed_rooms: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	generate()

func generate():
	var start_room = rooms.pick_random().instantiate()
	add_child(start_room)
	start_room.position = Vector2.ZERO
	placed_rooms.append(start_room)
	
	while placed_rooms.size() < max_rooms:
		try_add_room(rooms)

func try_add_room(multi_rooms: Array):
	var base_room = placed_rooms.pick_random()
	var base_conections = base_room.get_node("Conexiones").get_children()
	
	if base_conections.is_empty():
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
	
	if not overlaps(new_room):
		placed_rooms.append(new_room)
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
	
	for r in placed_rooms:
		var r_rect = Rect2(r.global_position, r.size)
		if room_rect.intersects(r_rect):
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
