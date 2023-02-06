extends Spatial

var done

func _physics_process(delta):
	if !$fire.get("emitting") and !$shrapnal.get("emitting"):
		done = true
		queue_free()

# Called when the node enters the scene tree for the first time.
func explode():
	$fire.emitting = true
	$shrapnal.emitting = true
