extends Control
# This scene serves as the main menu for the game. Menu is a control node that frames the whole thing.
# The Transition animation node uses a black ColorRect to perform a fade in transition from a black screen
# to the pixelated campus with the title and buttons (start, load, and quit game), all while paying a theme.
class_name MainMenu

# Prepare fade in animation (refer to the Transition node for more)
@onready var transition = $Transition
@onready var mainScene = preload("res://scenes/player_example.tscn")

func _ready():
	# Plays the fade animation at the beginning.
	transition.play("fade")


# When the user presses the start button, a new game begins with the example scene.
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")

# Once implemented, pressing Load Game will allow the user to restore their progress (when they last saved).
func _on_load_pressed():
	pass
	
# Pressing Quit Game, quits the game.
func _on_quit_pressed():
	get_tree().quit()

