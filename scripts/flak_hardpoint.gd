extends "res://scripts/ship_hardpoint.gd"

func _ready():
	max_hp = 100
	hp = 100
	$placeholder.visible = false
	
	set_turret_type("flak")

	pass
#end ready

func _process(delta):
	._process(delta)
	#$ammotxt.text = str(main_weapon.ammo)
