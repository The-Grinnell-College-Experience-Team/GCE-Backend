extends Area2D

signal battle()

@export var dialogue_start: String = 'start'

# function to call dialogue file upon interaction with NPC
func action():
	DialogueManager.show_example_dialogue_balloon( load("res://dialogue/cindy.dialogue"), dialogue_start)

# simply a function to connect the battle signal for future development
func _on_battle():
	print('testing')
