extends attack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = 0.75

func animacion():
	var aniSprite = get_parent().get_parent().get_parent().get_node("AnimatedSprite2D")
	if aniSprite.flip_h:
		for c in get_children():
			if c.position.x > 0:
				c.position.x = -(abs(c.position.x))
			else:
				c.position.x = abs(c.position.x)
	else:
		for c in get_children():
			if c.position.x < 0:
				c.position.x = abs(c.position.x)
			else:
				c.position.x = -(abs(c.position.x))
	aniSprite.play("Bo")
