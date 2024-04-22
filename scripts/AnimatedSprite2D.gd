extends CharacterBody2D

class_name MainChar

# Paths to save game data
var save_file_path = "user://save/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

# Node references
@onready var animation_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var ray_cast = $RayCast2D
@onready var side_menu = preload("res://scenes/side_menu.tscn")

## this will determine the player's speed
#var speed = 200

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
	# check if the file path to save data exists
	var exists = verify_save_directory(save_file_path)
	#if exists == true:
		#pass
	#else:
		#playerData = PlayerData.new()

# check if path exists
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	
# load the data from the file system
func load_data():
	var exists = ResourceLoader.exists(save_file_path + save_file_name)
	if exists == true:
		playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		on_start_load()
		print("loaded")
	else:
		print("Error loading game")
	return playerData

# save the data to the file system	
func save():
	var error =ResourceSaver.save(playerData, save_file_path + save_file_name)
	if error == OK:
		print("save")
	else:
		print("Error saving game")
	
func on_start_load():
	self.position = playerData.SavePos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var motion = Vector2()
	
	# define our inputs
	var moveRight = Input.is_action_pressed('move_right')
	var moveLeft = Input.is_action_pressed('move_left')
	var moveUp = Input.is_action_pressed('move_up')
	var moveDown = Input.is_action_pressed('move_down')
	
	# apply movement and appropriate animation
	if moveRight:
		motion.x += 100
		# determine if we choose an animation or if we're already animated
		if not (moveUp or moveDown):
			$AnimatedSprite2D.play(animation_walk_right)
		movedDir = idle_state.RIGHT
		isMoved = true
	if moveLeft:
		motion.x -= 100
		# determine if we choose an animation or if we're already animated
		if not (moveUp or moveDown):
			$AnimatedSprite2D.play(animation_walk_left)
		movedDir = idle_state.LEFT
		isMoved = true
	if moveUp:
		motion.y -= 100
		# determine if we choose an animation or if we're already animated
		if not (moveRight or moveLeft):
			$AnimatedSprite2D.play(animation_walk_up)
		movedDir = idle_state.UP
		isMoved = true
	if moveDown:
		motion.y += 100
		# determine if we choose an animation or if we're already animated
		if not (moveRight or moveLeft):
			$AnimatedSprite2D.play(animation_walk_down)
		movedDir = idle_state.DOWN
		isMoved = true
	# Turn RayCast2D toward movement direction  
	if motion != Vector2.ZERO:
		ray_cast.target_position = motion.normalized() * 50
	
	# determine whether we need to put the character into an idle animation
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
					
	# this normalizes the motion vector and multiplies it by the speed we want
	motion = motion.normalized() * playerData.speed
	position += motion * delta	
	
	# reset our animation boolean for the next iteration of _process
	isMoved = false
	pass
	
	playerData.UpdatePos(self.position)

func _input(event):
	#interact with NPCs        
	if event.is_action_pressed("ui_interact"):
		var target = ray_cast.get_collider()
		if target != null and target.is_in_group("NPC"):
			# Talk to NPC
			target.dialog()
	else:
		pass
		
	## open the side menu        
	#if event.is_action_pressed("ui_menu"):
		#if not has_node("SideMenu"):
			#var sideMenu = side_menu.instance()
			#add_child(sideMenu)
			#get_tree().paused = true
	
	# handle save and load data
	# for now, save = key 9, load = key 0
	if Input.is_action_just_pressed("save"):
		save()
	if Input.is_action_just_pressed("load"):
		load_data()
	

# if press side menu button, open the side menu window
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/side_menu.tscn")
