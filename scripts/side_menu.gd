extends ColorRect

var selected_menu = 0

func change_menu_color():
	$SaveButton/ColorRect.color = Color("ffd0a0")
	$LoadButton/ColorRect.color = Color("ffd0a0")
	$RestartButton/ColorRect.color = Color("ffd0a0")
	$QuitButton/ColorRect.color = Color("ffd0a0")
	
	match selected_menu:
		0:
			$SaveButton/ColorRect.color = Color("dcff64")
		1:
			$LoadButton/ColorRect.color = Color("dcff64")
		2:
			$RestartButton/ColorRect.color = Color("dcff64")
		3:
			$QuitButton/ColorRect.color = Color("dcff64")

			
func _input(_event):
	# if press "Down"
	if Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 4
		change_menu_color()
	# if press "Up"
	elif Input.is_action_just_pressed("ui_up"):
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 3
		change_menu_color()
	# if press "Enter"
	elif Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0:
				print("Save")
			1:
				print("Load")
			2:
				print("Restart")
			3:
				get_tree().quit()

# When press save button, save the ongoing game.
func _on_save_button_pressed():
	pass # Replace with function body.

# When press load button, load the saved game.
func _on_load_button_pressed():
	pass # Replace with function body.

# When the user presses the restart button, 
# a new game begins with the example scene.
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")

# Pressing Quit Game, quits the game.
func _on_quit_button_pressed():
	get_tree().quit()
