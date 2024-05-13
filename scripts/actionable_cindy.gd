extends Area2D

signal battle()

@export var dialogue_start: String = 'start'

func action():
	DialogueManager.show_example_dialogue_balloon( load("res://dialogue/cindy.dialogue"), dialogue_start)

func _on_battle():
	print('testing')
