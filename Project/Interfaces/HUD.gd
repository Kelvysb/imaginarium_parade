extends CanvasLayer

class_name HUD

@onready var lives = $Control/HBoxContainer/Lives
@onready var score = $Control/HBoxContainer2/Score
@onready var special = $Control/HBoxContainer3/Special

func SetLifes(value: int):
	lives.text = str(value)

func SetScore(value: int):
	score.text = str(value)
	
func SetSpecial(value: int):
	special.value = value
