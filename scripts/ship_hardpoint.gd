extends "res://scripts/general_space_object.gd"



var type = "laser_gun"

var parent #parent ship

var weapon #the hardpoints weapon
#how long it takes to repair it after its dystroyed
var regen_turret_timer = 30 
var regen_turret_timer_counter = 0 
var dont_regen
var disable_all

onready var guns = $guns

# Called when the node enters the scene tree for the first time.
func _ready():
	
	max_hp = 10
	hp = 10
	yrange = 3000
	speed = 0
	max_shield = 0
	shield = 0
	
	$placeholder.visible = false
	
	set_turret_type()
	pass
#end ready

func _process(delta):
	if disable_all:return
	if disabled:
		visible = false
		if !dont_regen:regen_turret_do(delta)
		return
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
func take_dmg(hit):
	if disabled:return
	ai_combat.take_dmg(self,hit,false)
	ai_combat.is_dead(self,1,1,false)
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
#end is_aim_at_parrent

func regen_turret_do(delta):
	regen_turret_timer_counter +=delta
	if regen_turret_timer <= regen_turret_timer_counter :
		regen_turret_timer_counter = 0
		disabled = false
		visible = true
		hp = max_hp
	pass
#end regen_turret_do

func set_parrent(p):
	parent = p
	team = parent.team
	main_weapon.team = team
	pass
#end get target

func set_turret_type(ytype="laser_gun"):
	type = ytype
	add_to_group("hardpoint")
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
	if type == "flak":
		main_weapon.yinit(self,1,true) 
		main_weapon.max_ammo = 500
		main_weapon.reload()
		main_weapon.uses_ammo = true
		main_weapon.weapon_name ="flak"
	pass
#end get target
