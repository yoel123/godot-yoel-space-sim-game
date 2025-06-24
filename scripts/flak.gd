extends Area

var dmg = 30
var team = 3
func _ready():
#	$shrapnal.emitting = true
	add_to_group("bullet")
	pass
#end ready

func emit(): $shrapnal.emitting = true

func _physics_process(delta):
	hit_do()
	if !$shrapnal.get("emitting"):
		queue_free()
#end _physics_process

func hit_do():
	var hit = get_overlapping_areas()
	
	if hit :
		#the area parent (the object)
		hit = hit[0].get_parent()
		if hit.is_in_group("hardpoint") :return
		#random chance to damage target
		if(hit.has_method("take_dmg")) : 
			hit.take_dmg(self)
			queue_free() #remove self
		#if its a rocket or bomb/torpedo dystroy it
		#if its a player add a very small screen shake
	

