extends KinematicBody

var ye = load("res://yframework.gd").new()
var bullet = preload("res://bullet.tscn")
var explosion  = preload("res://explosion.tscn")
var ai_movement = load("res://ai_movement.gd").new()

var target

var rotate_speed = 0.5
var speed = 3
var velocity

var weapon_range = 300

export var team = 2

onready var modal = $modal

var hp = 100
var max_hp = 100
var dead

var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group("big ship")
	
	#change color to red if team 2
	if team ==2:
		var material = SpatialMaterial.new()
		material.albedo_color = Color(1, 0.0, 0.0)
		modal.set_surface_material(2,material)
		
	#loop all hardpoint and pass self as parrent
	for hardpoint in $hardpoints.get_children():
		hardpoint.set_parrent(self)
		pass
		
	pass 
# end _ready


func _physics_process(delta):
	get_target(delta)
	move(delta)
	pass

func get_target(delta):
	if !target:
		#search for another big ship
		var yships = ye.get_by_type(self,"big ship") 
		for ship in yships:
			if ship.team != team:
				 target = ship #set player as target
		pass
	pass
	
	
func move(delta):
	if !target || dead || !is_instance_valid(target):return
	#rotate to target
	ye.look_at_slow(self,delta,target,rotate_speed)
	#print(self,delta,target,rotate_speed)
	
	#get distance from target
	
	
	var dist = ye.dist_3dvt(self,target.global_transform.origin)
	if dist <weapon_range:return #stop moving if in weapon range
	
	#move to target
	velocity = -transform.basis.z * speed
	#move
	move_and_collide(velocity * delta)
	
	pass #end move

func shot(delta):
	
	
	pass 
#end shot

func take_dmg(hit):
	
	#remove bullet
	hit.queue_free()

	#no friendly fire only bullet from not your team can damage
	var hteam = hit.team
	if hteam != team:
		hp-=hit.dmg #else reduce hull hp
	#if dead do explosion
	if hp<=0:
		dead = true
		for i in 10: #make 10 explotions
			var boom = explosion.instance()
			owner.add_child(boom)
			var rnd_pos = ai_movement.rend_3d_pos(rng,30) #random 3d vector
			#add rrandom vector to ships position and set it as current explotion pos
			boom.global_transform.origin = self.global_transform.origin+rnd_pos
			boom.explode()
		queue_free()
	pass 
#end take_dmg

	
