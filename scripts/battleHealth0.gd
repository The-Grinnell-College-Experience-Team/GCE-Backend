extends Node2D

# set up our battle ststs for both the enemy and player
var max_enemy_health = 354
var current_enemy_health  = 354

var max_player_health = 500
var current_player_health  = 500

var player_strength = 75
var current_player_strength = 75
var enemy_strength = 100
var current_enemy_strength = 150

var player_hotness = 100
var enemy_hotness = 20

# set up battle setting constants
var timewait = 0.75
var finishedBattle = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# we initialize our health bars for the enemy and player
	$EnemyHealth.min_value = 0
	$EnemyHealth.max_value = max_enemy_health
	$EnemyHealth.value = current_enemy_health
	
	$PlayerHealth.min_value = 0
	$PlayerHealth.max_value = max_player_health
	$PlayerHealth.value = current_player_health
	
	finishedBattle = false
	pass # Replace with function body.

# a simple function to update the enemy health bar to the set value
# input: an integer for the updated health
# output: void
func set_enemy_health(new_health):
	current_enemy_health = new_health
	$EnemyHealth.value = current_enemy_health
	pass
	
# a simple function to update the enemy health bar to the set value
# input: an integer for the updated health
# output: void
func set_enemy_strength(new_strength):
	current_enemy_strength = new_strength
	pass
	
# a simple function to subtract the enemy health bar by the set value
# input: an integer for the difference in health
# output: void
func subtract_enemy_health(difference):
	set_enemy_health(current_enemy_health - difference)
	pass

# a simple function to subtract the enemy health bar by the set value
# input: an integer for the difference in health
# output: void
func subtract_enemy_strength(difference):
	if (current_enemy_strength - difference > 0):
		set_enemy_strength(current_enemy_strength - difference)
	pass

# a simple function to update the player health bar to the set value
# input: an integer for the updated health
# output: void
func set_player_health(new_health):
	current_player_health = new_health
	$PlayerHealth.value = current_player_health
	pass
	
# a simple function to subtract the player health bar by the set value
# input: an integer for the difference in health
# output: void
func subtract_player_health(difference):
	set_player_health(current_player_health - difference)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


signal npc_attack

# a function to subtract the enemy health by the player's strength upon pressing the attack button
# then the function signals for the NPC's turn to play out
func _on_attack_button_pressed():
	# attack the enemy
	subtract_enemy_health(current_player_strength)
	
	# end the game if the enemy loses all health
	if current_enemy_health <= 0:
		get_tree().change_scene_to_file("res://scenes/player_example.tscn")
		finishedBattle = true
		pass
	
	# disable the attack button until the enemy has attacked
	$Panel/AttackButton.disabled = true
	
	# if the battle hasn't finished, then we signal the NPC's attack
	if not finishedBattle:
		await get_tree().create_timer(timewait).timeout
		npc_attack.emit()
	
	pass 

# a function to subtract the enemy strength by the player's strength upon pressing the attack button
# then the function signals for the NPC's turn to play out
func _on_flirt_button_pressed():
	# attack the enemy
	subtract_enemy_strength(player_hotness)
	
	# disable the attack button until the enemy has attacked
	$Panel/AttackButton.disabled = true
	
	# if the battle hasn't finished, then we signal the NPC's attack
	if not finishedBattle:
		await get_tree().create_timer(timewait).timeout
		npc_attack.emit()
	
	pass 

# a function to subtract the player health by the enemy's strength upon getting the signal for it
func _on_npc_attack():
	# attack the player
	subtract_player_health(current_enemy_strength)
	
	# end the game if the player loses all health
	if current_player_health <= 0:
		get_tree().change_scene_to_file("res://scenes/player_example.tscn")
		finishedBattle = true
		pass
		
	# if the battle hasn't finished, then we signal the NPC's attack
	if not finishedBattle:
		await get_tree().create_timer(timewait).timeout
	
	# re-enable the player's attack for their turn
	$Panel/AttackButton.disabled = false
	
	pass 
