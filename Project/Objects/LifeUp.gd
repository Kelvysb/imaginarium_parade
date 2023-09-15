extends RigidBody2D
class_name LifeUp

@export var Speed : float  = 100

func _ready():
	apply_impulse(Vector2(0.0, Speed))

func Kill():
	queue_free()
	
func Destruct():
	Kill()
