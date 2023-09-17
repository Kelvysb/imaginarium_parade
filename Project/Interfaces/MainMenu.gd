extends Control

@onready var start = $VBoxContainer/Start

func _ready():
	start.grab_focus()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Interfaces/Controls.tscn")


func _on_about_pressed():
	get_tree().change_scene_to_file("res://Interfaces/About.tscn")


func _on_exit_pressed():
	get_tree().quit()
