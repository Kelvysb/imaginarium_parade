extends RigidBody2D
class_name Obstacle

@export var Speed : float  = 100

const Points = 10
var fragments = preload("res://Objects/ObstacleBreak.tscn")

func _ready():
	apply_impulse(Vector2(0.0, Speed))
	apply_torque_impulse(randf_range(20,50))

func Kill():
	var frag = fragments.instantiate() as Node2D
	frag.global_position = global_position
	get_parent().add_child(frag)
	queue_free()
	
func Destruct():
	Kill()
