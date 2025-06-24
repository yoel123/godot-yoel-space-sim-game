extends Node
var ye = load("res://scripts/yframework.gd").new()
var bullet = load("res://scripts/bullet_factory.gd").new()
var weapon_db = load("res://scripts/weapon_db.gd").new()

var that

var weapon_name ="normal"
var shot_timer = 0.2
var shot_counter = 0
var dmg = 10
var bullet_speed = 150
var bullet_life = 2

var team = 1

var is_ai

#if the weapon uses ammo
var uses_ammo
var max_ammo = 50
var ammo = 50

var recharge_rate = 0.5
var recharge_counter = 0
var dont_aim

func _ready():
	set_weapon_stats_by_name(weapon_name)
	pass 

func yinit(that2,fire_rate=0.2,is_ai2 = false):
	that = that2
	shot_timer = fire_rate
	team = that.team
	is_ai = is_ai2
	pass 




func can_shot_ai(delta):
	shot_counter+=delta
	if  shot_timer<=shot_counter:
		shot_counter=0
		return true
	pass
#end can_shot_ai

func can_shot(delta,button):
	shot_counter+=delta
	if shot_timer <= shot_counter and Input.is_action_pressed(button) :
		shot_counter = 0 #reset firate timer
		return true
	pass 
#end can_shot

func make_bullet(gun):
	
	#no ammo? exit
	if ammo<=0:return
	ammo-=1 #reduce 1 ammo per bullet made/shot
	
	#help ai aim at target
	if is_ai:aim_gun(gun)
	var b
	#create bullet
	if(weapon_name =="normal"): b = bullet.normal(self,gun)
	if(weapon_name =="missile"): b = bullet.guided_missile(self,gun)
	if(weapon_name =="dumb_missile"): b = bullet.dumb_missile(self,gun)
	if(weapon_name =="flare"): b = bullet.flare(self,gun)
	if(weapon_name =="flak"): b = bullet.flak(self,gun)
	

	
	return b
	pass
#end make_bullet

func aim_gun(gun):
	if !that.targ:return
	#get weapon owner target
	var targ = that.targ
	
	#for laser or if you wont it to most lickly miss a little
	if dont_aim:
		gun.look_at(targ.global_transform.origin,Vector3.UP)
	else:
		#aim bullet at the target plus its volocity (to track the target)
		gun.look_at(targ.global_transform.origin+targ.velocity,Vector3.UP)


func reload():ammo = max_ammo

func recharge(delta):
	#if  uses ammo or has max ammo exit
	if uses_ammo || ammo==max_ammo:return
	
	#when recharge rate timer is done
	recharge_counter += delta
	if recharge_counter>recharge_rate:
		recharge_counter=0
		ammo+=1 #add 1 ammo

	
	pass
#end recharge
	
func get_ammo_hud(): return float(ammo)/max_ammo *100
	
func update(delta):
	recharge(delta)

func set_weapon_stats_by_name(name):
	
	weapon_db.set_weapon(name,self)
	pass
