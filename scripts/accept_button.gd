extends Button

# simply assigns the button to the 'ui_accept' action
func _on_pressed():
	Input.action_press("ui_accept")
