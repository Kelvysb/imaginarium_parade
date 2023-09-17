extends AnimatableBody2D

@export var Speed : float = 25.0
@export var Delay : float = 5.0
@export var Lifetime : float = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Delay <= 0:
		position.y = lerpf(position.y, position.y + Speed, 0.1)
		Lifetime -= delta
	else:
		Delay -= delta
	if Lifetime <= 0:
		queue_free()
