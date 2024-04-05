extends Control

@onready var transition = $Transition

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")


func _on_load_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()

func _ready():
	transition.play("fade")
