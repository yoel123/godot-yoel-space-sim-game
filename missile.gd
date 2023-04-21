extends KinematicBody

var ye = load("res://yframework.gd").new()
var ai_movement = load("res://ai_movement.gd").new()
var ai_combat = load("res://ai_combat.gd").new()

var targ
var speed = 160
var dmg = 6

var movment_type = "hooming"

var life_timer = 2
var life_counter = 0

var team = 1

var lock_after_lunch
var lock_timer = 0.4
var lock_timer_counter = 0

func _ready():
	add_to_group("missile")
	pass # Replace with function body.

func _physics_process(delta):
	
	#life timer (remove when ends)
	life_counter+=delta
	if life_counter>life_timer: queue_free()	
	
	move(delta)
	
	#get overlapping areas if any
	var hit = $Area.get_overlapping_areas()
	
	#if there are overlapping areas
	if hit :
		#get the first one
		hit = hit[0].get_parent()
		
		if !"team" in hit: return
		
		#dont hit self
		if hit.team && hit.team == team:return
		
		#check if the object has method take dmg 
		#if so use it and pass this object 
		if(hit.has_method("take_dmg")): hit.take_dmg(self)
		#queue_free() #remove self
		#print("hit")
	
	
	
	pass #end _physics_process


func move(delta):
	
	
	
	
	if movment_type =="dumb_fire":
		#if its a missile that locks on after lunch
		if lock_after_lunch:
			lock_timer_counter +=delta
			if lock_timer< lock_timer_counter:movment_type ="hooming"
		
		transform.origin += -transform.basis.z * speed * delta
		pass
	
	if movment_type =="hooming":
		#set first enemy as target for now
		if !targ:
			var targs = ai_combat.get_fighters(self)
			if targs and targs[0]:
				 targ = targs[0] #set first enemy as target
		
		#try locking on flare
		ai_combat.lock_on_closest_flare(self)
		
		#move twords target  
		#is_instance_valid checks if object is not deleated when godot does
		#queue_free it dosnt remove the object
		if targ && is_instance_valid(targ):
			ai_movement.home(self,delta,speed)
		else:movment_type ="dumb_fire" #change to dumb fire if no target
		
	pass #end move

