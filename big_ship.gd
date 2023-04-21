extends KinematicBody

var ye = load("res://yframework.gd").new()
var bullet = preload("res://bullet.tscn")
var explosion  = preload("res://explosion.tscn")
var ai_movement = load("res://ai_movement.gd").new()
var ai_combat = load("res://ai_combat.gd").new()

var ship_name = "heavy_shuttle"

var targ

var rotate_speed = 0.4
var speed = 3
var velocity

var weapon_range = 300

export var team = 2

onready var modal = $modal

var hp = 100
var max_hp = 100
var dead
var create_ship_wreck_once

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
	if !targ:
		ai_combat.lock_on_closest_big_ship(self,1500)
		pass
	pass
	
	
func move(delta):
	if !targ || dead || !is_instance_valid(targ):return

	if ai_movement.follow(self,delta,weapon_range):return
	
	ai_movement.move_forwerd(self,delta,speed)

	
	pass #end move

func shot(delta):
	
	
	pass 
#end shot

func take_dmg(hit):
	ai_combat.take_dmg(self,hit,false)
	ai_combat.is_dead(self,15,30)
	pass 
#end take_dmg

	
