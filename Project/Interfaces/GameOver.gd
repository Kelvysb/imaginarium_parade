extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Stages/springStage.tscn")

func _on_exit_pressed():
	get_tree().quit()
