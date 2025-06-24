extends "res://scripts/ship_hardpoint.gd"

func _ready():
	$placeholder.visible = false
	
	set_turret_type("mini_rockets")

	pass
#end ready

func _process(delta):
	._process(delta)
	#$ammotxt.text = str(main_weapon.ammo)
