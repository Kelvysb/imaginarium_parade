extends AnimatableBody2D
class_name Plataform

var fragments = preload("res://Objects/PlataformBreak.tscn")
@export var Speed : float = 25.0
@export var Delay : float = 0.0

func _process(delta):
	if Delay <= 0:
		position.y = lerpf(position.y, position.y + Speed, 0.1)
	else:
		Delay -= delta

func Destruct():
	var frag = fragments.instantiate() as Node2D
	frag.global_position = global_position
	get_parent().add_child(frag)
	queue_free()
