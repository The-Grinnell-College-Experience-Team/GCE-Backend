extends Node
# This scene serves as a autoload (global variable) and updates the checkpoints for the save/load system.

# checks whether the load func is requried and saved character position needs to be loaded
var isLoaded : bool = false	
# checks whether the load func is requried and saved character position needs to be loaded
var isSaved : bool = false
# check whether the load func is requried and needs go back to the current character position
var needsPrevPos : bool = false	 
