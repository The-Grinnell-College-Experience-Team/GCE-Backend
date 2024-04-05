extends Node2D

var max_enemy_health = 354
var current_enemy_health  = 354

var max_player_health = 500
var current_player_health  = 500

var player_strength = 75
var enemy_strength = 45

var timewait = 0.75

var finishedBattle = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyHealth.min_value = 0
	$EnemyHealth.max_value = max_enemy_health
	$EnemyHealth.value = current_enemy_health
	
	$PlayerHealth.min_value = 0
	$PlayerHealth.max_value = max_player_health
	$PlayerHealth.value = current_player_health
	
	finishedBattle = false
	pass # Replace with function body.


func set_enemy_health(new_health):
	current_enemy_health = new_health
	$EnemyHealth.value = current_enemy_health
	pass
	
func subtract_enemy_health(difference):
	set_enemy_health(current_enemy_health - difference)
	pass

func set_player_health(new_health):
	current_player_health = new_health
	$PlayerHealth.value = current_player_health
	pass
	
func subtract_player_health(difference):
	set_player_health(current_player_health - difference)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


signal npc_attack

func _on_attack_button_pressed():
	subtract_enemy_health(player_strength)
	
	if current_enemy_health <= 0:
		get_tree().change_scene_to_file("res://scenes/player_example.tscn")
		finishedBattle = true
		pass
	
	$Panel/AttackButton.disabled = true
	
	if not finishedBattle:
		await get_tree().create_timer(timewait).timeout
		npc_attack.emit()
	
	pass # Replace with function body.


func _on_npc_attack():
	subtract_player_health(enemy_strength)
	
	if current_player_health <= 0:
		get_tree().change_scene_to_file("res://scenes/player_example.tscn")
		pass
		
	await get_tree().create_timer(timewait).timeout
	
	$Panel/AttackButton.disabled = false
	
	pass # Replace with function body.
