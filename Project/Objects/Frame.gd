extends Node2D

@onready var bottom = $Bottom

func _process(delta):
	check_player()

func check_player():
	var bodies = bottom.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			body.Damage()
			break
	
func _on_bottom_body_entered(body):
	if (body as Node2D).is_in_group("destructable"):
		body.Destruct()
