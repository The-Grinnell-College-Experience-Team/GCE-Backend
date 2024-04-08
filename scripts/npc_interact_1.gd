extends CharacterBody2D
## npc_interact_1 is attached to npc_interact_1 scene 
## and handles its object status.
##
## It handles the general npc_interact_1 object status (e.g. idle)
## and calls DialogPopUp to show the interaction between tha main character and NPC.
## Every NPC objects show different dialog content depending on @fakeprocess()

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
	dialog_popup.message = "Hellooooo"
	dialog_popup.response = "[C] Pretty Good  [B] Bad"
	dialog_popup.open() #re-open to show next dialog
	await get_tree().create_timer(0.5).timeout
	fakeprocess()

var aPressed = false
var bPressed = false

func fakeprocess():
	while true:
		if dialog_state == 1 and Input.is_action_pressed('KEY_C'):
			# Update dialog tree state
			dialog_state = 2
			# Show dialog popup
			dialog_popup.message = "Great! Hope you enjoy the days!"
			dialog_popup.response = "[A] Bye"
			fakeprocess()
			break
		elif dialog_state == 1 and Input.is_action_pressed('KEY_B'):
			# Update dialog tree state
			dialog_state = 3
			# Show dialog popup
			dialog_popup.message = "Hope you find a good memory today."
			dialog_popup.response = "[A] Bye"
			fakeprocess()
			break
		elif dialog_state == 2 and Input.is_action_pressed('KEY_A'):
			# Update dialog tree state
			dialog_state = 1
			# Close dialog popup
			dialog_popup.close()
			# Set NPC's animation back to "idle"
			animation_sprite.play("idle_down")
		elif dialog_state == 3 and Input.is_action_pressed('KEY_A'):
			# Update dialog tree state
			dialog_state = 1
			# Close dialog popup
			dialog_popup.close()
			# Set NPC's animation back to "idle"
			animation_sprite.play("idle_down")
			break
		await get_tree().create_timer(0.01).timeout

func _process(delta):
	time += delta

