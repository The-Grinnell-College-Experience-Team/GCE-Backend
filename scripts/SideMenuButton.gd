extends MenuButton
# This scene serves as an input handler for the side menu button of the main scene.

# preload the side menu scene
@onready var side_menu = preload("res://scenes/side_menu.tscn")

# If press the side menu icon (top right corner of the screen),
# it opens the new window, the side menu
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/side_menu.tscn")
