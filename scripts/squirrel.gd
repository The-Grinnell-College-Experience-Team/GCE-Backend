extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

var veloc = Vector2.ZERO
var movement_timer = 0
var min_walk_time = 1
var max_walk_time = 5
var walk_speed = 1000

func _ready():
	set_process(true)

func _process(delta):
	movement_timer -= delta
	if movement_timer <= 0:
		# Choose a random direction
		var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		velocity = direction * walk_speed
		movement_timer = randf_range(min_walk_time, max_walk_time)
	else:
		velocity = Vector2.ZERO

	move_and_slide()

