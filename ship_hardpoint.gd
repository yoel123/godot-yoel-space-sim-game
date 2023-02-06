extends Spatial

var ye = load("res://yframework.gd").new()
var bullet = preload("res://bullet.tscn")
var explotion  = preload("res://explotion.tscn")
var main_weapon = load("res://weapon.gd").new()


var type = "laser_gun"

var parent #parent ship
var targ #the target that the hardpoint will shot at

var weapon #the hardpoints weapon
var team

var max_hp = 10
var hp = 10

var yrange = 3000

var guns

# Called when the node enters the scene tree for the first time.
func _ready():
	$placeholder.visible = false
	
	set_turret_type()
	pass # Replace with function body.

func _process(delta):
	if check_targ_not_exist():get_target()
	shot(delta)
#end _process

func _physics_process(delta):
	
	pass


func get_target():
	
	
	#loop smal big and player ship and if one is close target it
	
	#try targeting small ship
	var small_ships = ye.get_by_type(self,"enemy") #get all small ships
	
	#add player to small ships
	var yplayers = ye.get_by_type(self,"player") 
	if yplayers[0] && is_instance_valid(yplayers[0]): small_ships.append(yplayers[0])
	
	small_ships.shuffle()
	
	#loop all small ships
	for ship in small_ships:
		var dist = ye.dist_3d(self,ship) #get distance between self and ship
		#if in range and not on the same team set as target
		if dist<= yrange && team !=ship.team:
			targ = ship
			return
	
	#try targeting big ship
	var big_ships = ye.get_by_type(self,"big ship")
	#loop all big ships
	for ship in big_ships:
		var dist = ye.dist_3d(self,ship)
		if dist<= yrange && team !=ship.team:targ = ship
	pass
		#print(targ)
	#for now aim at player
	"""
	if team == 2:
		#search for player
		var yplayers = ye.get_by_type(self,"player") 
		if yplayers and yplayers[0]:
			 targ = yplayers[0] #set player as target
	"""	
	pass
#end get target

func shot(delta):
	#if no target or if target deleted from scene
	if check_targ_not_exist():return
	
	look_at(targ.global_transform.origin,Vector3.UP)
	#if aming at parrent stop shooting
	if is_aim_at_parrent(): return
	
	if main_weapon.can_shot_ai(delta):
		for gun in guns.get_children():
			var b = main_weapon.make_bullet_ai(gun)
#end shot
func take_dmg(dmg):
	pass
#end get target

func check_targ_not_exist():
	if !targ || !is_instance_valid(targ):return true

func is_aim_at_parrent():
	var colide_parent = $ray.get_collider()
	if colide_parent && colide_parent.get_parent()==parent: return true
	
	pass

func set_parrent(p):
	parent = p
	team = parent.team
	pass
#end get target

func set_turret_type(ytype="laser_gun"):
	type = ytype
	
	if type =="laser_gun":
		#pass this obj refrence to weapon and fire rate
		main_weapon.yinit(self,0.5) 
	
		guns = $laser_gun/guns
	
	
	pass
#end get target
