extends ColorRect
# This scene serves as the new window for the side menu.
# It provides four options: save, load, restart, and quit.

# the path to the main scene
const main_scene_path = "res://scenes/player_example.tscn"

# When press save button, save the ongoing game and go back to the main scene.
func _on_save_button_pressed():
	Global.needsPrevPos = true
	Global.isSaved = true
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_scene_path))

# When press load button, load the saved game.
func _on_load_button_pressed():
	Global.isLoaded = true
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_scene_path))

# When the user presses the restart button, 
# a new game begins with the example scene.
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

# Pressing Quit Game, quits the game.
func _on_quit_button_pressed():
	get_tree().quit()

# Pressing the 'x' button on the right top, 
# close the side menu, go back to the current position, and resume the game.
func _on_exit_menu_button_pressed():
	Global.needsPrevPos = true
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_scene_path))
