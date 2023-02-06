extends Spatial

var ye = load("res://yframework.gd").new()

export var mission_type = "destroy"
export var mission_targets = ""



onready var parent = get_owner()

#timer vur survival/defend missions
export var mission_timer = 20
var mission_timer_count = 0

#an array of objects with areas the player needs to reach to finish a mission
var mission_goto_locations


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	
	if mission_type== "destroy": destroy_target() 
	if mission_type== "survive": survive(delta) 
	if mission_type== "defend": destroy_target() 
	if mission_type== "go to": destroy_target() 
	if mission_type== "escort": destroy_target() 
	
	pass

func destroy_target():
	
	#if dystroyed all targets go to next mission
	if check_if_all_targets_destroyed():print("mission done")
#end  destroy_target()  

func survive(delta):
	#incrament timer
	mission_timer_count +=delta
	
	#if all targets you need to defend are destroyed you lose
	if check_if_all_targets_destroyed():
		print("mission lost")
		return #exit function
	
	#if timer is done you survived (you win)
	if mission_timer_count>=mission_timer:
		print("mission done")
	
	pass
#end survive

#checks if all "mission_targets" are destroyed (retyrns true)
func check_if_all_targets_destroyed():
	#convet mission_targets string to array
	var targs_to_destroy = mission_targets.split(",")
	#get the number of targets needed to dystroy
	var target_count = targs_to_destroy.size()
	#the count of dystroyd targets
	var target_dead_count = 0
	
	#loop all target names
	for target_name in targs_to_destroy:
		#get target scene by its name
		var targ = ye.get_scene_by_name(self,target_name)
		#if scene is removed (destroyed)
		if !is_instance_valid(targ):
			target_dead_count+=1 #incrament target_dead_count
		pass
	
	pass
	#if all targets are destroyed return true
	if target_count == target_dead_count:return true

