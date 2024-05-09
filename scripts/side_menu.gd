extends ColorRect
# This scene serves as the new window for the side menu.
# It provides four options: save, load, restart, and quit.

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
	
	## Update the status
	#loading_status = ResourceLoader.load_threaded_get_status(main_scene_path, progress)
	#Global.isLoaded = true
	#
	## Check the loading status
	#match loading_status:
		#ResourceLoader.THREAD_LOAD_LOADED:
			## When done loading, change to the main scene
			#get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_scene_path))
		#ResourceLoader.THREAD_LOAD_FAILED:
			## Some error happened
			#print("Error. Could not load Resource")

# When the user presses the restart button, 
# a new game begins with the example scene.
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

# Pressing Quit Game, quits the game.
func _on_quit_button_pressed():
	get_tree().quit()

func _on_exit_menu_button_pressed():
	Global.needsPrevPos = true
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_scene_path))
