extends Resource
# This scene serves as the resource saver for game data.
# It updates and saves the main character data as it is updated in the main scene.

class_name PlayerData

# consistently updated whenever the user saves the game
@export var level = 1	# level of the main character (currently not used)
@export var speed = 200	# spped of the main chracter (currently not used)
@export var SavePos : Vector2	 # previously saved position of the main character
@export var CurPos : Vector2	# current position of the main character

# change the character level and save its value
# (currently not used)
func change_level(value: int):
	level += value
	
# update the character position and save its value
# mostly used when loading the game data by load buttons
func UpdatePos(value : Vector2):
	SavePos = value

# update the character's current position and save its value
# mostly used when going back to the previous character position after exiting the side menu
func UpdateCurPos(value : Vector2):
	CurPos = value


