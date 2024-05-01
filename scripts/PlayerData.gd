extends Resource

class_name PlayerData

# consistently updated whenever the user saves the game
@export var level = 1
@export var speed = 200
@export var SavePos : Vector2

func change_level(value: int):
	level += value
	
func UpdatePos(value : Vector2):
	SavePos = value


