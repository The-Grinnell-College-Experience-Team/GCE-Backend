extends CharacterBody2D

# Node references
@onready var dialog_popup = get_node("/root/Player/CharacterBody2D/UI/DialogPopup")
@onready var player = get_tree().root.get_node(".")
@onready var animation_sprite = $AnimatedSprite2D

# dialog states
var dialog_state = 0

# npc name
@export var npc_name = ""

const SPEED = 300.0
const JUMP_VELOCITY = -40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var time = 0

# initialize variables
func _ready():
	animation_sprite.play("idle_down")


func _physics_process(delta):

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# get it moving upward
		velocity.y = JUMP_VELOCITY
		# timer for half a second
		await get_tree().create_timer(0.5).timeout
		# get it moving downward
		velocity.y = 0 - JUMP_VELOCITY
		# timer for half a second
		await get_tree().create_timer(0.5).timeout
		# make it stop moving
		velocity.y = 0
		
		

	move_and_slide()

var runDialog = false

#dialog tree    
func dialog():
	runDialog = true
	# Set our NPC's animation to "talk"
	animation_sprite.play("talk_down")   
	# Set dialog_popup npc to be referencing this npc
	dialog_popup.npc = self
	# Update dialog tree state
	dialog_state = 1
	
	# Show dialog popup
	dialog_popup.message = "BAAAAAAAAAKAAAAAAAAAAA! You dare battle a sugoi otaku like me?!?!?!?"
	dialog_popup.response = "[C] yea  [B] No I'm too scared"
	dialog_popup.open() #re-open to show next dialog
	fakeprocess()

var aPressed = false
var bPressed = false


func saveScene():
	var file = FileAccess.open("res://scenes/saved_scene.tscn", FileAccess.WRITE)
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	file.store_line(packed_scene.to_string())
	file.close()

func fakeprocess():
	while true:
		if dialog_state == 1 and Input.is_action_pressed('KEY_C'):
			# Update dialog tree state
			dialog_state = 0
			dialog_popup.close()
			# Show dialog popup
			#var next_scene = preload("res://scenes/battle_0.tscn").instantiate()
			#get_tree().root.add_child(next_scene)
			#get_tree().change_scene("res://scenes/battle_0.tscn")
			saveScene()
			
			'''
			# preload the next scene
			var next_scene = preload("res://scenes/battle_0.tscn").instantiate()
			
			# remove the current scene
			if get_tree().current_scene:
				get_tree().current_scene.queue_free()
			
			# add the next scene to the tree
			get_tree().root.add_child(next_scene)
			get_tree().current_scene = next_scene
			'''
			get_tree().change_scene_to_file("res://scenes/battle_0.tscn")

			
			print("onto the next one")
			
			#get_tree().change_scene("res://scenes/battle_0.tscn")
			
			#dialog_popup.message = "Great! Hope you enjoy the days!"
			#dialog_popup.response = "[A] Bye"
			
			#fakeprocess()
			break
		elif dialog_state == 1 and Input.is_action_pressed('KEY_B'):
			# Update dialog tree state
			dialog_state = 3
			# Show dialog popup
			dialog_popup.message = "Hope you find a good memory today."
			dialog_popup.response = "[A] Bye"
			await get_tree().create_timer(0.5).timeout
			fakeprocess()
			break
		elif dialog_state == 2 and Input.is_action_pressed('KEY_A'):
			# Update dialog tree state
			dialog_state = 0
			# Close dialog popup
			dialog_popup.close()
			# Set NPC's animation back to "idle"
			animation_sprite.play("idle_down")
			await get_tree().create_timer(0.5).timeout
		elif dialog_state == 3 and Input.is_action_pressed('KEY_A'):
			# Update dialog tree state
			dialog_state = 0
			# Close dialog popup
			dialog_popup.close()
			# Set NPC's animation back to "idle"
			animation_sprite.play("idle_down")
			await get_tree().create_timer(0.5).timeout
			break
		await get_tree().create_timer(0.01).timeout

func _process(delta):
	time += delta

