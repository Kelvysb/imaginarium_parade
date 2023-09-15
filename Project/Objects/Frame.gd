extends Node2D

func _on_bottom_body_entered(body):
	if (body as Node2D).is_in_group("destructable"):
		body.Destruct()
	elif (body as Node2D).is_in_group("player"):
		(body as Player).Damage()
