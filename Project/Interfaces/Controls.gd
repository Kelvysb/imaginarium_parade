extends Control
@onready var exit = $VBoxContainer/Exit

func _ready():
	exit.grab_focus()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Stages/springStage.tscn")


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Stages/springStage.tscn")
