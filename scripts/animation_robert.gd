extends CharacterBody2D

@onready var player = get_tree().root.get_node(".")
@onready var animation_sprite = $AnimatedSprite2D

# npc name
@export var npc_name = "The Ghost of Robert Noyce"

const SPEED = 300.0
const JUMP_VELOCITY = -40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var time = 0

# initialize variables
func _ready():
	animation_sprite.play("idle_down")




func _process(delta):
	time += delta

