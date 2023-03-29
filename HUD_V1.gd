extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var value_hull : float = 0
var value_shield : float = 0
var value_throttle : float = 0

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
