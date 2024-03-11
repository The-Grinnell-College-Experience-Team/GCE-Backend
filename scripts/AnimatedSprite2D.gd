extends CharacterBody2D

# this will determine the player's speed
var speed = 200

# animation constants
var animation_right = "right"
var animation_left = "left"
var animation_up = "up"
var animation_down = "down"
var animation_walk_right = "walk_right"
var animation_walk_left = "walk_left"
var animation_walk_up = "walk_up"
var animation_walk_down = "walk_down"


enum idle_state {RIGHT, LEFT, UP, DOWN}
var movedDir = idle_state.DOWN
var isMoved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interacted(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_ballloon(load("res://dialogues/example.dialogue"), "start")
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var motion = Vector2()
	var moveRight = Input.is_action_pressed('move_right')
	var moveLeft = Input.is_action_pressed('move_left')
	var moveUp = Input.is_action_pressed('move_up')
	var moveDown = Input.is_action_pressed('move_down')
	
	
	if moveRight:
		motion.x += 100
		if not (moveUp or moveDown):
			$AnimatedSprite2D.play(animation_walk_right)
		movedDir = idle_state.RIGHT
		isMoved = true
	if moveLeft:
		motion.x -= 100
		if not (moveUp or moveDown):
			$AnimatedSprite2D.play(animation_walk_left)
		movedDir = idle_state.LEFT
		isMoved = true
	if moveUp:
		motion.y -= 100
		if not (moveRight or moveLeft):
			$AnimatedSprite2D.play(animation_walk_up)
		movedDir = idle_state.UP
		isMoved = true
	if moveDown:
		motion.y += 100
		if not (moveRight or moveLeft):
			$AnimatedSprite2D.play(animation_walk_down)
		movedDir = idle_state.DOWN
		isMoved = true
	
	match isMoved:
		false:
			match movedDir:
				idle_state.RIGHT:
					$AnimatedSprite2D.play(animation_right)
				idle_state.LEFT:
					$AnimatedSprite2D.play(animation_left)
				idle_state.UP:
					$AnimatedSprite2D.play(animation_up)
				idle_state.DOWN:
					$AnimatedSprite2D.play(animation_down)
					
	motion = motion.normalized() * speed
	position += motion * delta	
	
	isMoved = false
	pass
