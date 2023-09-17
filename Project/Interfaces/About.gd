extends Control

@onready var exit = $VBoxContainer/Exit

func _ready():
	exit.grab_focus()
	
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Interfaces/MainMenu.tscn")
