extends Area2D
class_name attack

var damage
var poisonous:= false
var poison_time:= 0.0
var freezer:= false
var freeze_time:= 0.0

func change_stats(new_d, new_p, new_pt, new_f, new_ft):
	damage+=new_d
	if new_p:
		poisonous = true
	poison_time+=new_pt
	if new_f:
		freezer = true
	freeze_time+=new_ft
	

func atacar():
	get_parent().get_node("AnimationPlayer").play("Attack")
