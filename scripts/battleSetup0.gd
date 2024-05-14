extends Panel

# this script is generally unused under current circumstances
# the intent of this script is to update, then load a save file upon winning a battle
# designed for future development

func _on_attack_button_pressed():
	print("Attack selected")

func _on_run_button_pressed():
	print("Run selected")
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")

func loadScene():
	var file = FileAccess.open("res://saved_scene.tscn", FileAccess.READ)
	var packed_scene = PackedScene.new()
	if packed_scene.can_instance():
		var scene = packed_scene.instance()
		get_tree().get_root().add_child(scene)
		get_tree().set_current_scene(scene)
	file.close()

