extends Spatial

var distance
var timer = 3
var timer_count = 0
var mesh


var dmg = 1

var team = 1

var parent
var disabled

func _ready():
	mesh = $shape/MeshInstance
	add_to_group("laser")
		
func _process(delta):
	if disabled :
		$shape.visible = false
		return
	make_laser()
	damage_target()
	timer_do(delta)

	pass

pass #end _process

func make_laser():
	$shape.visible = true
	#$shape.transform.origin = transform.origin
	# Check for a raycast collision.
	if $RayCast.get_collider(): 
		# Calculating the distance between the laser and a collision point.
		distance = transform.origin.distance_to($RayCast.get_collision_point())
		# Scaler is scaling to the collision point.
		#$shape.scale.z = distance
		#$shape.transform.origin.z =$shape.scale.z*0.02
	else:
		# If the raycast is not colliding  with anything then the Scaler's scale is long as the raycast length.
		$shape.scale.z = $RayCast.cast_to.z	
		#move scaled object
		$shape.transform.origin.z =$shape.scale.z*0.02#40#$RayCast.cast_to.z	
		pass
	pass
#end make_laser

func timer_do(delta):
	timer_count+=delta
	if  timer<=timer_count:
		timer_count=0
		#mesh.visible = false
	pass
#end timer_do

func damage_target():
	#if hit somthing
	var hit = $RayCast.get_collider()
	
	if hit:
		if(hit.has_method("take_dmg")) : hit.take_dmg(self)
	pass
