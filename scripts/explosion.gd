extends Spatial

var done
var timer_counter = 0

func _physics_process(delta):
	"""
	if !$fire.get("emitting") and !$shrapnal.get("emitting"):
		done = true
		queue_free()
	"""
	#remove after timer is done
	timer_counter +=delta
	if timer_counter > 8:queue_free()


# Called when the node enters the scene tree for the first time.
func explode():
	#$fire.emitting = true
	#$shrapnal.emitting = true
	$EffekseerEmitter.play()

