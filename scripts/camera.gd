extends Area2D

# this will determine the camera's speed
var speed = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var motion = Vector2()
	
	# determine which motion change to utilize
	if Input.is_action_pressed('move_right'):
		motion.x -= 100
	if Input.is_action_pressed('move_left'):
		motion.x += 100
	if Input.is_action_pressed('move_up'):
		motion.y += 100
	if Input.is_action_pressed('move_down'):
		motion.y -= 100
	
	# this normalizes the motion vector and multiplies it by the speed we want
	motion = motion.normalized() * speed
	
	# update the position
	position += motion * delta	
	
	pass
