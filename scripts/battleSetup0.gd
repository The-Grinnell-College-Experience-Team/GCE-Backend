extends Panel

func _on_attack_button_pressed():
	print("Attack selected")

func _on_run_button_pressed():
	print("Run selected")
	print("yeehaw2")
	get_tree().change_scene_to_file("res://scenes/player_example.tscn")

func loadScene():
	var file = FileAccess.open("res://saved_scene.tscn", FileAccess.READ)
	var packed_scene = PackedScene.new()
	if packed_scene.can_instance():
		var scene = packed_scene.instance()
		get_tree().get_root().add_child(scene)
		get_tree().set_current_scene(scene)
	file.close()

