extends Area

var ye = load("res://scripts/yframework.gd").new()

var speed = 150

var life_timer = 2
var life_counter = 0

var dmg = 1

var team = 1
var parent


func _ready():
	add_to_group("bullet")
	pass #end ready

	hit_do()

func _physics_process(delta):
	#move
	transform.origin += -transform.basis.z * speed * delta
	hit_do()
	#life timer (remove when ends)
	life_counter+=delta
	life_timer_do()
#end _physics_process

#check for collition with bullet
func hit_do():
		#if hit somthing
	var hit = get_overlapping_areas()
	
	if hit :
		#the area parent (the object)
		hit = hit[0].get_parent()
		did_hit(hit)
		#print(str(hit.get_name()))
		#print("hit"+str(randi()) )
	pass
#end hit

#what happens to the hit object
func did_hit(hit):
	if(hit.has_method("take_dmg")) && hit !=parent: 
		hit.take_dmg(self)
		queue_free() #remove self
	pass
#end did_hit

func life_timer_do():
	if life_counter>life_timer: queue_free()

