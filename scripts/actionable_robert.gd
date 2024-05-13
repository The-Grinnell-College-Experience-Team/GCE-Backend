extends Area2D

signal battle()

@export var dialogue_start: String = 'start'

func action():
	DialogueManager.show_example_dialogue_balloon( load("res://dialogue/robert.dialogue"), dialogue_start)
	pass
	
func _on_battle():
	print('testing')
