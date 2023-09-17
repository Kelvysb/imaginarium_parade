extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_continue_pressed():	
	get_tree().paused = false
	hide()


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Interfaces/MainMenu.tscn")
