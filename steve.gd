extends CharacterBody2D

# Node references
@onready var dialog_popup = get_node("/root/Player/CharacterBody2D/UI/DialogPopup")
@onready var player = get_tree().root.get_node(".")
@onready var animation_sprite = $AnimatedSprite2D # Created by Alex with the help of Jasper

# dialog states
var dialog_state = 0

# npc name
@export var npc_name = "Campo Steve"

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
	animation_sprite.play("idle_down")   
	# Set dialog_popup npc to be referencing this npc
	dialog_popup.npc = self
	# Update dialog tree state
	dialog_state = 1
	
	# Show dialog popup written by Jasper
	dialog_popup.message = "Hi! The kids call me Campo Steve. I hope you enjoy Grinnell! If you need a ride in my golf cart, let me know."
	# Dialog response option for user
	dialog_popup.response = "[C] Bye"
	dialog_popup.open() #re-open to show next dialog
	await get_tree().create_timer(0.5).timeout
	fakeprocess()

var aPressed = false
var bPressed = false

func fakeprocess():
	# Continously run fake process
	while true:
		if dialog_state == 1 and Input.is_action_pressed('KEY_C'):
			# Update dialog tree state with key press
			dialog_state = 1
			# Close dialog popup
			dialog_popup.close()
			# Set NPC's animation back to "idle"
			animation_sprite.play("idle_down")
		await get_tree().create_timer(0.01).timeout

func _process(delta):
	time += delta

# In this NPC file of Alex's, Jasper rewrote the dialogue tree to be 1 line, and Jasper showed Alex how to
# create and implement the animated sprite for Campo Steve.
