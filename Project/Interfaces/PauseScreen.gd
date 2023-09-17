extends CanvasLayer
@onready var continueButton = $Control/VBoxContainer/Continue

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().paused = false
		hide()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	continueButton.grab_focus()

func _on_continue_pressed():	
	get_tree().paused = false
	hide()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Interfaces/MainMenu.tscn")
