extends CanvasLayer

class_name HUD

@onready var score = $Control/HBoxContainer2/Score
@onready var special = $Control/HBoxContainer3/Special
@onready var life1 = $Control/HBoxContainer/Life1
@onready var life2 = $Control/HBoxContainer/Life2
@onready var life3 = $Control/HBoxContainer/Life3
var currentLifes = 0

func SetLifes(value: int):	
	if not currentLifes == value:
		if value == 3:
			life1.visible = true
			life2.visible = true
			life3.visible = true
		elif value == 2:
			life1.visible = true
			life2.visible = true
			life3.visible = false
		elif value == 1:
			life1.visible = true
			life2.visible = false
			life3.visible = false
		else:
			life1.visible = false
			life2.visible = false
			life3.visible = false

func SetScore(value: int):
	score.text = str(value)
	
func SetSpecial(value: int):
	special.value = value
