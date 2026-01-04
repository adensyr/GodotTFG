extends GameObject

var fuego:= false
var hielo:= false
var veneno:= false
var rayo:= false
var botasPincho:= false

func _ready() -> void:
	tooltip = "Esto te hará recibir menos daño"

func buscar_sinergias():
	var objetos = player.get_node("ItemBag").get_children()
	for o in objetos:
		match o.name:
			"Fuego": fuego = true
			"Hielo": hielo = true
			"Veneno": veneno = true
			"Rayo": rayo = true
			"Botas_pincho": botasPincho = true
