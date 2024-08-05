extends Control

var paused = false

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if paused != true:
			paused = true
		else: paused = false
	get_tree().paused = paused
	visible = paused
	
	if paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_resume_pressed():
	paused = false


func _on_main_menu_pressed():
	print("main menu")


func _on_quit_pressed():
	get_tree().quit()
