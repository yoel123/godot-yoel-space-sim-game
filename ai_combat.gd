extends Node

var wrekege_maker = load("res://wrekege_maker.gd").new()
var ai_movement = load("res://ai_movement.gd").new()
var ye = load("res://yframework.gd").new()
var explosion  = preload("res://explosion.tscn")

func take_dmg(that,hit,has_shield=true):
		#remove bullet
	hit.queue_free()

	#no friendly fire only bullet from not your team can damage
	var hteam = hit.team
	if hteam != that.team:
		if has_shield:
			shield_dmg(that,hit)
		else:that.hp-=hit.dmg
#end take_dmg

#handale taking shield dmg
func shield_dmg(that,hit):
	if that.shield>0:
		that.shield-=hit.dmg #if thers shield reduce it
		that.get_node("shieldmesh").visible=true #show shield mesh
		if that.shield<=0:that.hp-=hit.dmg #if passed shields
	else:that.hp-=hit.dmg #else reduce hull hp
#end shield_dmg


func is_dead(that,explotion_num,explotion_range):
	if that.hp<=0:
		that.dead = true
		that.queue_free()
		explotions_gen(that,explotion_num,explotion_range)
		wrekege_maker.gen(that,that.ship_name)
		
		
func explotions_gen(that,num,yrange):
	for i in num: #make 10 explotions
		var boom = explosion.instance()
		that.owner.add_child(boom)
		var rnd_pos = ye.rend_3d_pos(that.rng,yrange) #random 3d vector
		#add rrandom vector to ships position and set it as current explotion pos
		#if thers more then one explotion place it in random pos
		if i>1:boom.global_transform.origin = that.global_transform.origin+rnd_pos
		else:boom.global_transform = that.global_transform
		boom.explode()
#end explotion_gen

#############lock on stuff####################

func get_fighters(that): return  ye.get_by_type(that,"fighter")

func lock_on_closest_fighter(that,dist,with_flares=false):
	
	#get all fighters
	var fighters = get_fighters(that)
	
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
	var big_ships = ye.get_by_type(that,"big ship")
	#loop all big ships
	for ship in big_ships:
		#distance between that and current ship
		var dist_from_me = ye.dist_3d(that,ship)
		#if distance from this object and ship is less then dist and not on the same team
		#set target to ship
		if dist_from_me<= dist && that.team !=ship.team:that.targ = ship
	pass
#end lock_on_closest_big_ship

func lock_on_closest_flare(that):
	var flares = []
	var fighters = get_fighters(that)
		
	#loop all fighters
	for fighter in fighters:
		#if its a flare add to flares  (and make sure its not on the same team)
		if fighter.is_flare  && fighter.team != that.team: flares.append(fighter)

	for flare in flares:
		#if a flare is close lock on it
		var dist_from_flare = ye.dist_3d(that,flare)
		if dist_from_flare < 200: 
			that.targ = flare
			return
	
#end lock_on_closest_flare

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
