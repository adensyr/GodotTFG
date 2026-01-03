extends Area2D
class_name attack

var damage
var poisonous:= false
var poison_time:= 0.0
var freezer:= false
var freeze_time:= 0.0
var atacando:= false
var color:= Color("ffffffff")

func change_stats(new_d, new_p, new_pt, new_f, new_ft, new_c):
	damage+=new_d
	if new_p:
		poisonous = true
	poison_time+=new_pt
	if new_f:
		freezer = true
	freeze_time+=new_ft
	if new_c:
		color = new_c

func atacar():
	animacion()
	get_parent().get_node("AnimationPlayer").play("Attack")

func animacion():
	pass
