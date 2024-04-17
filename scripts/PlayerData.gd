extends Resource

class_name PlayerData

@export var level = 1
@export var speed = 200

# consistently updated whenever the user saves the game
@export var SavePos : Vector2

func change_level(value: int):
	level += value
	
func UpdatePos(value : Vector2):
	SavePos = value


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
