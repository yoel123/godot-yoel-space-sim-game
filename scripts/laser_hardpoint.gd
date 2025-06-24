extends "res://scripts/ship_hardpoint.gd"

var laser_power = 50
var laser_power_max = 50

var charge_laser_timer = 3
var charge_laser_timer_counter = 0


func _ready():
	max_hp = 10
	hp = 10
	$placeholder.visible = false
	
	set_turret_type("tactical_laser")
	$laser.team = team
	pass
#end ready

func _process(delta):
	if disable_all:
		$laser.disabled = true
		return
	._process(delta)
	laser_disable(delta)
	#$ammotxt.text = str(main_weapon.ammo)



func shot(delta):
	#if no target or if target deleted from scene
	if check_targ_not_exist():return
	
	look_at(targ.global_transform.origin,Vector3.UP)
	#if aming at parrent stop shooting
	if is_aim_at_parrent(): return
	
	#dont make bullet
	
#end shot

func laser_disable(delta):
	#if no target disable laser
	if(!is_instance_valid(targ)):$laser.disabled = true
	else:$laser.disabled = false
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(0, charge_laser_timer)
	
	#reduce power
	laser_power -=1
	#disable if power less then 0
	if laser_power<=0:
		$laser.disabled = true
		charge_laser_timer_counter +=delta
		#recharge timer
		if charge_laser_timer_counter>charge_laser_timer:
			charge_laser_timer_counter = num 
			laser_power = laser_power_max
			$laser.disabled = false
		
