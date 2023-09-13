extends AnimatableBody2D
class_name Plataform

@onready var collision = $Collision

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Destruct():
	queue_free()
