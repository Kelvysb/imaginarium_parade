extends Control

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Interfaces/MainMenu.tscn")
