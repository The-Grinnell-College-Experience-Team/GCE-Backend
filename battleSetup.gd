extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func loadScene():
	var file = FileAccess.open("res://saved_scene.tscn", FileAccess.READ)
	var packed_scene = PackedScene.new()
	if packed_scene.can_instance():
		var scene = packed_scene.instance()
		get_tree().get_root().add_child(scene)
		get_tree().set_current_scene(scene)
	file.close()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	#interact with world        
	if event.is_action_pressed("KEY_A"):
		print("yeehaw2")
		get_tree().change_scene_to_file("res://scenes/player_example.tscn")
		
		pass
	else:
		pass
