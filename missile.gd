extends KinematicBody

var ye = load("res://yframework.gd").new()

var targ
var speed = 60
var dmg = 6

var movment_type = "hooming"

var life_timer = 30
var life_counter = 0

var team = 1

func _ready():
	add_to_group("missile")
	pass # Replace with function body.

func _physics_process(delta):
	move(delta)
	
	#get overlapping areas if any
	var hit = $Area.get_overlapping_areas()
	
	#if there are overlapping areas
	if hit :
		#get the first one
		hit = hit[0].get_parent()
		#check if the object has method take dmg 
		#if so use it and pass this object 
		if(hit.has_method("take_dmg")): hit.take_dmg(self)
		queue_free() #remove self
		#print("hit")
	
	
	pass #end _physics_process


func move(delta):
	
	
	
	
	if movment_type =="dumb_fire":
		transform.origin += -transform.basis.z * speed * delta
		pass
	
	if movment_type =="hooming":
		#set first enemy as target for now
		if !targ:
			var targs = ye.get_by_type(self,"enemy") 
			if targs and targs[0]:
				 targ = targs[0] #set first enemy as target
		
		#move twords target  
		#is_instance_valid checks if object is not deleated when godot does
		#queue_free it dosnt remove the object
		if targ && is_instance_valid(targ):
			#change rotation to target rotation
			look_at(targ.global_transform.origin,Vector3.UP)
			#change move vector to target direction
			var dir = (targ.transform.origin - transform.origin).normalized()
			move_and_collide(dir*speed *delta)
		else:movment_type ="dumb_fire" #change to dumb fire if no target
		
	pass #end move

