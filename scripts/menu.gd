extends Control
# This scene serves as the main menu for the game. Menu is a control node that frames the whole thing.
# The Transition animation node uses a black ColorRect to perform a fade in transition from a black screen
# to the pixelated campus with the title and buttons (start, load, and quit game), all while paying a theme.
class_name MainMenu

# Prepare fade in animation (refer to the Transition node for more)
@onready var transition = $Transition
@onready var playerData = PlayerData.new()

# Initialize variables for loading the main scene
const main_scene_path = "res://scenes/player_example.tscn"
var loading_status : int
var progress : Array[float]

# This function is called once when the current scene is instantiated.
func _ready():
	# Plays the fade animation at the beginning.
	transition.play("fade")
	# Request to load the main scene
	ResourceLoader.load_threaded_request(main_scene_path)

# When the user presses the start button, a new game begins with the example scene.
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")

# Once implemented, pressing Load Game will allow the user to restore their progress (when they last saved).
func _on_load_pressed():
	# checkpoint to load the previous game data
	Global.isLoaded = true
	# update the status
	loading_status = ResourceLoader.load_threaded_get_status(main_scene_path, progress)
	
	# check the loading status
	match loading_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			# when done loading, change to the main scene
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_scene_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			# some error happened
			print("Error. Could not load Resource")
	
# Pressing Quit Game, quits the game.
func _on_quit_pressed():
	get_tree().quit()
	

