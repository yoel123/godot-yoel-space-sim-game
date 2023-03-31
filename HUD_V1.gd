extends Control

var ye = load("res://yframework.gd").new()

var value_ownship_hull : float = 0
var value_ownship_shield : float = 0
var value_ownship_throttle : float = 0

# Setup camera button
var button_camera_event = InputEventAction.new()


onready var Data_Target = $Data_Target
onready var ProgressBar_Hull = $Data_Target/ProgressBar_Hull
onready var ProgressBar_Shield = $Data_Target/ProgressBar_Shield

var player


func _ready():
	# Initialise dummy values (not functional yet)
	value_ownship_hull = 100
	value_ownship_shield = 50
	value_ownship_throttle = 70
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_hud()
	
	update_target_stats()
	
	# If buttons are pressed, trigger event
	# Parse generated event
	Input.parse_input_event(button_camera_event)
	button_camera_event.action = "camera_toggle"
	
	# If pressed, set event to true
	if ($Data_Buttons/Button_Camera.pressed == true):
		button_camera_event.pressed = true
	# If not pressed, set to false
	else:
		button_camera_event.pressed = false
#end process


func update_target_stats():
	
	if !player:return
	if !player.targ || !is_instance_valid(player.targ):return
	
	
	var targ_data = player.targ.get_hull_and_shield()
	
	ProgressBar_Hull.value = targ_data[0]
	ProgressBar_Shield.value = targ_data[1]
	
	
	
	pass
#end update_target_stats


func _update_hud():
	
	#get player refrence	
	if !player:
		var players = ye.get_by_type(self,"player")
		if players[0]:player =players[0] 
	
	
	# Set ProgressBar values
	$Data_Ship/ProgressBar_Hull.value = value_ownship_hull
	$Data_Ship/ProgressBar_Shield.value = value_ownship_shield
	$Data_Controls/ProgressBar_Throttle.value = player.get_throttle()
pass
#end _update_hud
