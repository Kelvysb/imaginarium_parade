extends Control

@onready var score = $HBoxContainer/Score

func _ready():
	var global = get_node("/root/GlobalGameData") as GameData
	score.text = str(global.TotalScore)

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Interfaces/MainMenu.tscn")


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Stages/springStage.tscn")
