extends Node

var ye = load("res://yframework.gd").new()

#the max value of the random pos
var move_random_range = 150

#look_at_slow(that,delta,targ,rotate_speed)

#change rotation towerds a random target slow
func move_to_random_pos(that,delta,rng,distance_from_targ):
	#set random targ
	if that.rnd_targ_reached || !that.rnd_targ:
		#reset target reached
		that.rnd_targ_reached = false
		#reset random target to new target
		rng.randomize()
		that.rnd_targ = Vector3(rng.randi_range(-move_random_range,move_random_range),rng.randi_range(-move_random_range,move_random_range),rng.randi_range(-move_random_range,move_random_range))
		#add target position to random pos (so you get a random position around the target)
		that.rnd_targ = that.rnd_targ + that.targ.global_transform.origin
		pass
	#end set random targ
	
	#distance from random target	
	var dist = ye.dist_3dvt(that,that.rnd_targ)

	#if reached close to random target
	if dist < distance_from_targ:
		that.rnd_targ_reached=true	
		return true	
	#rotate to target
	ye.look_at_slowv(that,delta,that.rnd_targ,that.rotate_speed)
	pass
#end follow

#change rotation towerds a target slow
func follow(that,delta,dist_to_evade):
	
	#if too close evade
	var dist = ye.dist_3d(that,that.targ)
	if dist < dist_to_evade:return true
	#rotate to target
	ye.look_at_slow(that,delta,that.targ,that.rotate_speed)
	pass
#end move_to_random_pos

func move_forwerd(that,delta,speed):
	that.velocity = -that.transform.basis.z * speed
	#move
	that.move_and_collide(that.velocity * delta)
	pass
#end move_forwerd


func home(that,delta,speed):
	#change rotation to target rotation
	that.look_at(that.targ.global_transform.origin,Vector3.UP)
	#change move vector to target direction
	var dir = (that.targ.transform.origin - that.transform.origin).normalized()
	that.move_and_collide(dir*speed *delta)
	pass
#end home

func lock_on_closest_fighter(that,dist,with_flares=false):
	
	#get all fighters
	var fighters = ye.get_by_type(that,"enemy") 
	
	#add player to fighters
	var yplayers = ye.get_by_type(that,"player") 
	if yplayers[0] && is_instance_valid(yplayers[0]): fighters.append(yplayers[0])
		
	#shuffle them all
	fighters.shuffle()
	
	#loop all fighters
	for fighter in fighters:
		
		#make sure fighter is an active object "valid"
		if !is_instance_valid(fighter): continue #make sure its an active object
		
		#if you dont want to get/lock on a flare get next fighter		
		if !with_flares && fighter.get("is_flare") :continue
		
		#get distance of that from the fighter
		var dist_from_fighter = ye.dist_3d(that,fighter)

		#check if is in distance range and not on the same team
		if dist_from_fighter <dist and fighter.team !=that.team:
			that.targ = fighter #set this fighter as target
			return
	pass
#end lock_on_closest

func lock_on_closest_big_ship(that,dist):
	
	#try targeting big ship
	var big_ships = ye.get_by_type(self,"big ship")
	#loop all big ships
	for ship in big_ships:
		#distance between that and current ship
		var dist_from_me = ye.dist_3d(that,ship)
		#if distance from this object and ship is less then dist and not on the same team
		#set target to ship
		if dist_from_me<= dist && that.team !=ship.team:that.targ = ship
	pass
#end lock_on_closest_big_ship
	
func lock_on_closest_hardpoint(that,dist):
	#loop big ships get the first one in range
	#loop its hardpoints
	#return the first one in range
	pass
#lock_on_closest_hardpoint

#lock on rockets bombs etc for point defence weapons
func lock_on_closest_torpedo(that,dist):
	#get all torpedos and bombs
	#put them in one array
	#shuffle it
	#loop it
	#get distance between object and that
	#return the first one in dist range
	pass
#lock_on_closest_torpedo


