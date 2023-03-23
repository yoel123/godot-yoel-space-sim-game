extends Node2D

var player
var enemy 
var indicator_sprite

func _ready():
	player = get_parent().owner.get_node("player")
	enemy = get_parent()
	indicator_sprite = $Sprite 
	
func _process(delta):
	if enemy.team == 1:
		return #we target only enemy
	# Get the global position of the player and the target
	var player_position = player.global_transform.origin
	var enemy_position = enemy.global_transform.origin + enemy.velocity
	
	# Calculate the direction from the player to the enemy
	var direction = enemy_position - player_position
	direction = direction.normalized()
	
	# Calculate the position of the indicator sprite
	var indicator_position = enemy_position  + direction 
	
	# Set the position of the indicator sprite
	position = get_viewport().get_camera().unproject_position(indicator_position)

	# Check if the enemy node has the VisibilityNotifier node attached
	#and that its on screen,if not hide indicator
	if enemy.has_node("VisibilityNotifier") and enemy.get_node("VisibilityNotifier").is_on_screen():
		visible = true
	else:
		visible = false
