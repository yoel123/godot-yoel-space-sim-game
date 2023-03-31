extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var value_ownship_hull : float = 0
var value_ownship_shield : float = 0
var value_ownship_throttle : float = 0

# Setup camera button
var button_camera_event = InputEventAction.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialise dummy values (not functional yet)
	value_ownship_hull = 100
	value_ownship_shield = 50
	value_ownship_throttle = 70
	
	pass # Replace with function body.

func _update_hud():
	# Set ProgressBar values
	$Data_Ship/ProgressBar_Hull.value = value_ownship_hull
	$Data_Ship/ProgressBar_Shield.value = value_ownship_shield
	$Data_Controls/ProgressBar_Throttle.value = value_ownship_throttle
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_hud()
	
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
