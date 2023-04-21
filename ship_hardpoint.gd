extends Spatial

var ye = load("res://yframework.gd").new()
var ai_movement = load("res://ai_movement.gd").new()
var ai_combat = load("res://ai_combat.gd").new()
var bullet = preload("res://bullet.tscn")
var explosion  = preload("res://explosion.tscn")
var main_weapon = load("res://weapon.gd").new()


var type = "laser_gun"

var parent #parent ship
var targ #the target that the hardpoint will shot at

var weapon #the hardpoints weapon
var team

var max_hp = 10
var hp = 10

var yrange = 3000

onready var guns = $guns

# Called when the node enters the scene tree for the first time.
func _ready():
	$placeholder.visible = false
	
	set_turret_type()
	pass
#end ready

func _process(delta):
	if check_targ_not_exist():get_target()
	shot(delta)
	main_weapon.update(delta)
#end _process

func _physics_process(delta):
	
	pass


func get_target():
	
	
	ai_combat.lock_on_closest_fighter(self,yrange,true)
	
	return
	
	#try targeting big ship
	var big_ships = ye.get_by_type(self,"big ship")
	#loop all big ships
	for ship in big_ships:
		var dist = ye.dist_3d(self,ship)
		if dist<= yrange && team !=ship.team:targ = ship
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
			var b = main_weapon.make_bullet(gun)
#end shot
func take_dmg(dmg):
	pass
#end get target

func check_targ_not_exist():
	if !targ || !is_instance_valid(targ):return true

func is_aim_at_parrent():
	
	var colide_parent = $ray.get_collider()
	if colide_parent !=null:return
	#	if colide_parent.get_parent().is_in_group("big ship"):
	#		 return true 

	pass

func set_parrent(p):
	parent = p
	team = parent.team
	main_weapon.team = team
	pass
#end get target

func set_turret_type(ytype="laser_gun"):
	type = ytype
	
	if type =="laser_gun":
		#pass this obj refrence to weapon and fire rate
		main_weapon.yinit(self,0.5,true) 
		main_weapon.max_ammo = 200
		main_weapon.reload()
	if type =="mini_rockets":
		main_weapon.yinit(self,1,true) 
		main_weapon.max_ammo = 500
		main_weapon.reload()
		main_weapon.uses_ammo = true
		main_weapon.weapon_name ="missile"
	
	pass
#end get target
