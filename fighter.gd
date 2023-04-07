extends KinematicBody

var ye = load("res://yframework.gd").new()
var ai_movement = load("res://ai_movement.gd").new()
var bullet = preload("res://bullet.tscn")
var explosion  = preload("res://explosion.tscn")
var main_weapon = load("res://weapon.gd").new()

onready var enemy_pointer = $enemy_pointer

var rng = RandomNumberGenerator.new()

var max_hp = 5
var hp = 5

var max_shield = 20
var shield = 20
var shield_timer = 2
var shield_timer_count = 0

var max_speed = 35
var speed = 0
var rotate_speed = 0.5
var velocity = Vector3.ZERO

var targ_old
var targ

var rnd_targ
var rnd_targ_reached

var dead

var is_flare

var yrange =1000

var state ="move_random"#chase"

var trail 

export var team = 2

onready var modal = $modal

func _ready():
	trail = $trails.get_child(0)
	add_to_group("fighter")
	#pass this obj refrence to weapon and fire rate
	main_weapon.yinit(self,0.5,true) 

	if team ==1 && modal:
		var material = SpatialMaterial.new()
		material.albedo_color = Color(1, 0.63, 0.2)
		modal.set_surface_material(3,material)
		$target_tracker/Sprite.modulate  =  Color(0, 1, 0)
	pass #end ready


func _process(delta):
	if trail: trail.trails_handle(self,speed)
	main_weapon.update(delta)
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
	#if dead do explosion
	if hp<=0:
		dead = true
		var boom = explosion.instance()
		owner.add_child(boom)
		boom.global_transform = self.global_transform
		boom.explode()
		queue_free()
	pass #end take_dmg

	

func set_target():

	ai_movement.lock_on_closest_fighter(self,yrange)
			
	
	pass
#end set_target
	

func move(delta):

	
	#move twords target if close continue flying (dont run into target 
	#and get behind target)

	#check if target is valid
	if !targ || targ == null || !is_instance_valid(targ):
		speed = 0
		return
	else:speed = max_speed
	
	#do movment state		

	#####move to random pos######
	if state =="move_random":

		#if reached close to random target
		if  ai_movement.move_to_random_pos(self,delta,rng,40):
			rnd_targ_reached=true	
			state ="chase"	

		pass	
			
	#######chase target######
	if state =="chase":
		#foolow if too close change to move random
		if  ai_movement.follow(self,delta,40):state ="move_random"
		pass
	
	ai_movement.move_forwerd(self,delta,speed)
		
	pass #end move

func shield_do(delta):
	if has_node("shieldmesh") && $shieldmesh.visible==true:$shieldmesh.visible=false
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
			var b = main_weapon.make_bullet(gun)
			
	pass #end shot

func get_hull_and_shield():
	var hull_get = float(hp)/max_hp *100
	var shilds_get = float(shield)/max_shield *100
	
	return[hull_get,shilds_get]
	
	pass#end get_hud_and_shield



#smooth look at rotation (targ aka target and rotate_speed are needed to be set befor use)
func look_at_slow(delta,targ):
	
	var T=global_transform.looking_at(targ, Vector3(0,1,0))
	global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, delta*rotate_speed)
	global_transform.basis.x=lerp(global_transform.basis.x, T.basis.x, delta*rotate_speed)
	global_transform.basis.z=lerp(global_transform.basis.z, T.basis.z, delta*rotate_speed)
	pass #end look_at_slow
