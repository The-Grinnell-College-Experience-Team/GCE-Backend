extends MenuButton

@onready var side_menu = preload("res://scenes/side_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# If press the side menu icon (top right corner of the screen),
# it opens the new window, the side menu
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/side_menu.tscn")
