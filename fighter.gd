extends KinematicBody

var ye = load("res://yframework.gd").new()
var bullet = preload("res://bullet.tscn")
var explotion  = preload("res://explotion.tscn")
var main_weapon = load("res://weapon.gd").new()

onready var enemy_pointer = $enemy_pointer

var rng = RandomNumberGenerator.new()

var max_hp = 3
var hp = 3

var max_shield = 10
var shield = 20
var shield_timer = 2
var shield_timer_count = 0

var speed = 35
var rotate_speed = 0.5
var velocity

var targ_old
var targ

var rnd_targ
var rnd_targ_reached

var dead

var state ="move_random"#chase"

export var team = 2

onready var modal = $modal

func _ready():
	add_to_group("enemy")
	#pass this obj refrence to weapon and fire rate
	main_weapon.yinit(self,0.5) 

	if team ==1:
		var material = SpatialMaterial.new()
		material.albedo_color = Color(1, 0.63, 0.2)
		modal.set_surface_material(3,material)
		$target_tracker/Sprite.modulate  =  Color(0, 1, 0)
		print(enemy_pointer.get_node("tex").modulate)
	pass #end ready


func _process(delta):
	pass #end process

func _physics_process(delta):
	if !targ:set_target()
	move(delta)
	shot(delta)
	shield_do(delta)
	pass #end _physics_process

func take_dmg(hit):
	
	#remove bullet
	hit.queue_free()

	#no friendly fire only bullet from not your team can damage
	var hteam = hit.team
	if hteam != team:
		if shield>0:
			shield-=hit.dmg #if thers shield reduce it
			$shieldmesh.visible=true #show shield mesh
			if shield<=0:hp-=hit.dmg #if passed shields
		else:hp-=hit.dmg #else reduce hull hp
	#if dead do explotion
	if hp<=0:
		dead = true
		var boom = explotion.instance()
		owner.add_child(boom)
		boom.global_transform = self.global_transform
		boom.explode()
		queue_free()
	pass #end take_dmg

	

func set_target():
	#get player
	var yplayers = ye.get_by_type(self,"player") 
	if yplayers and yplayers[0]:
		var player_targ = yplayers[0]
		#if player not on the same team attack it and its a valid active object
		if player_targ.team != team and is_instance_valid(player_targ):
			var dist_from_player = ye.dist_3d(self,player_targ)
			#if player is in range set it as target
			if dist_from_player <300: targ = player_targ
			pass
		pass
		
	#loop all fighters,get the closest if not on same team set as target
	var fighters = ye.get_by_type(self,"enemy") 
	
	fighters.shuffle()
	
	for fighter in fighters:
		if !is_instance_valid(fighter): continue #make sure its an active object
		
		var dist_from_fighter = ye.dist_3d(self,fighter)
		if dist_from_fighter <1000 and fighter.team !=team:
			targ = fighter
			return
			
	
	pass
#end set_target
	

func move(delta):
	if targ == null:return
	#set player as target for now
	"""
	if targ == null:
		
		#search for enemy ships
		
		#search for player
		var yplayers = ye.get_by_type(self,"player") 
		if yplayers and yplayers[0]:
			 targ = yplayers[0] #set player as target
	"""
	#move twords target if close continue flying (dont run into target 
	#and get behind target)
	if targ && is_instance_valid(targ):
		
		#look_at(targ.global_transform.origin,Vector3.UP) #look at target pld

		#####move to random pos######
		if state =="move_random":
			#set random targ
			if rnd_targ_reached || !rnd_targ:
				#reset target reached
				rnd_targ_reached = false
				#reset random target to new target
				rng.randomize()
				rnd_targ = Vector3(rng.randi_range(-150,150),rng.randi_range(-150,150),rng.randi_range(-150,150))
				#add target position to random pos (so you get a random position around the target)
				rnd_targ = rnd_targ + targ.global_transform.origin
				pass
			#distance from random target	
			var dist = ye.dist_3dvt(self,rnd_targ)
			#if team ==1:print(dist," ",rnd_targ)
			#if reached close to random target
			if dist < 40:
				rnd_targ_reached=true	
				state ="chase"	
			#rotate to target
			look_at_slow(delta,rnd_targ)
			#old movment
			#var dir = (rnd_targ - transform.origin).normalized()
			#move_and_collide(dir*speed *delta)
			pass	
				
		#######chase target######
		if state =="chase":
			
			#if too close evade
			var dist = ye.dist_3d(self,targ)
			if dist < 40:state ="move_random"
			
			#rotate to target
			look_at_slow(delta,targ.global_transform.origin)
			#if team ==1:print(targ.global_transform.origin)
			#old movment
			#var dir = (targ.transform.origin - transform.origin).normalized()
			#move_and_collide((dir*speed) *delta)
			pass
		#enemy velocity (move forward
		velocity = -transform.basis.z * speed
		#move
		move_and_collide(velocity * delta)
		
	pass #end move

func shield_do(delta):
	if $shieldmesh.visible==true:$shieldmesh.visible=false
	#regenrate shield (if its not at max value
	if shield<max_shield:
		shield_timer_count+=delta
		if shield_timer_count>shield_timer:
			shield_timer_count = 0
			shield+=1

	
	pass#end shield_do
func shot(delta):
	#if no target return
	if !targ:return 
	#if target dystroyed removed or whatever
	if !is_instance_valid(targ):
		targ = null
		return
	#distance to target
	var dist = ye.dist_3d(self,targ)
	if dist < 100 and main_weapon.can_shot_ai(delta):
		#fire all guns
		for gun in $guns.get_children():
			#create shot
			var b = main_weapon.make_bullet_ai(gun)
			
	pass #end shot



#smooth look at rotation (targ aka target and rotate_speed are needed to be set befor use)
func look_at_slow(delta,targ):
	
	var T=global_transform.looking_at(targ, Vector3(0,1,0))
	global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, delta*rotate_speed)
	global_transform.basis.x=lerp(global_transform.basis.x, T.basis.x, delta*rotate_speed)
	global_transform.basis.z=lerp(global_transform.basis.z, T.basis.z, delta*rotate_speed)
	pass #end look_at_slow
