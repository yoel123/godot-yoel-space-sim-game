extends "res://scripts/general_space_object.gd"


onready var modal = $modal


func _ready():
	add_to_group("big ship")

	ship_name = "heavy_shuttle"
	rotate_speed = 0.4
	speed = 3
	#hp = 2000
	hp = 400
	max_hp = 2000
	death_explotion_effect = "energy_wave"
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
	ai_combat.is_dead(self,1,30,false)
	if dead:disable_hardpoints()
	pass 
#end take_dmg

func disable_hardpoints():
	for hardpoint in $hardpoints.get_children():
		hardpoint.disable_all = true
#end disable_hardpoints

	
