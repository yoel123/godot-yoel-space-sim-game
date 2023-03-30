extends Node
var ye = load("res://yframework.gd").new()
var bullet = load("res://bullet_factory.gd").new()

var that

var weapon_name ="normal"
var shot_timer = 0.2
var shot_counter = 0
var dmg = 1
var bullet_speed = 150

var team = 1

var is_ai

#if the weapon uses ammo
var uses_ammo
var max_ammo = 50
var ammo = 50

var recharge_rate = 0.5
var recharge_counter = 0


func _ready():

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
	

	
	return b
	pass
#end make_bullet

func aim_gun(gun):
	if !that.targ:return
	#get weapon owner target
	var targ = that.targ
	#aim bullet at the target plus its volocity (to track the target)
	gun.look_at(targ.global_transform.origin+targ.velocity,Vector3.UP)


func reload():ammo = max_ammo

func recharge(delta):
	#if dosnt use ammo and has less then max ammo
	if (!uses_ammo || uses_ammo==null) && ammo==max_ammo:return
	
	#when recharge rate timer is done
	recharge_counter += delta
	if recharge_counter>recharge_rate:
		recharge_counter=0
		ammo+=1 #add 1 ammo
		print("in")
	
	pass
#end recharge
	
func update(delta):
	recharge(delta)

func set_weapon_stats_by_name(name):
	
	if name == "blue laser":
		pass
	
	pass
