extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var value_hull : float = 0
var value_shield : float = 0
var value_throttle : float = 0

# Setup camera button
var button_camera_event = InputEventAction.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialise dummy values (not functional yet)
	value_hull = 100
	value_shield = 50
	value_throttle = 70
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Data/ProgressBar_Hull.value = value_hull
	$Data/ProgressBar_Shield.value = value_shield
	$Data/ProgressBar_Throttle.value = value_throttle
	
	# If buttons are pressed, trigger event
	# Parse generated event
	Input.parse_input_event(button_camera_event)
	button_camera_event.action = "camera_toggle"
	
	# If pressed, set event to true
	if ($Buttons/Button_Camera.pressed == true):
		button_camera_event.pressed = true
	# If not pressed, set to false
	else:
		button_camera_event.pressed = false
