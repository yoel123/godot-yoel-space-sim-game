extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var explosion_active: bool = false
export var explosion_radius: float = 1.00
export var explosion_opacity: float = 1.00


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (explosion_active == true):
		visible = true
	else:
		visible = false
	
	scale = explosion_radius * Vector3.ONE
	pass
