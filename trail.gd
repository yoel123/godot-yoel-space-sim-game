extends Spatial

func trails_handle(parent,speed):
	
	if speed >0.5:
		for ytrail in parent.get_node("trails").get_children():
			ytrail.get_node("trailp").emitting = true
	else:
		for ytrail in parent.get_node("trails").get_children():
			ytrail.get_node("trailp").emitting = false

