extends ColorRect
# This scene serves as the new window for the side menu.
# It provides four options: save, load, restart, and quit.

var selected_menu = 0
var mainChar = MainChar.new()

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
	pass

# When press save button, save the ongoing game.
func _on_save_button_pressed():
	mainChar.save()

# When press load button, load the saved game.
func _on_load_button_pressed():
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")
	mainChar.load_data()

# When the user presses the restart button, 
# a new game begins with the example scene.
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

# Pressing Quit Game, quits the game.
func _on_quit_button_pressed():
	get_tree().quit()

func _on_exit_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")
	mainChar.load_data()
