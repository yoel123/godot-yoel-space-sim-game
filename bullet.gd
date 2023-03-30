extends Area

var ye = load("res://yframework.gd").new()

var speed = 150

var life_timer = 2
var life_counter = 0

var dmg = 1

var team = 1



func _ready():
	add_to_group("bullet")
	pass #end ready



func _physics_process(delta):
	#move
	transform.origin += -transform.basis.z * speed * delta
	#if hit somthing
	var hit = get_overlapping_areas()
	
	if hit :
		#the area parent (the object)
		hit = hit[0].get_parent()
		if(hit.has_method("take_dmg")): hit.take_dmg(self)
		#print(str(hit.get_name()))
		#print("hit"+str(randi()) )
		
	
	#life timer (remove when ends)
	life_counter+=delta
	if life_counter>life_timer: queue_free()	

