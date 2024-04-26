extends Area2D

signal battle()

@export var dialogue_start: String = 'start'

func action():
	DialogueManager.show_example_dialogue_balloon( load("res://dialogue/anne.dialogue"), dialogue_start)
	pass
# DialogueManager.show_example_dialogue_balloon(load("res://dialogue/spoder_man.dialogue"), "start")

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_battle():
	print('testing')
	pass # Replace with function body.
