extends Spatial
var ye = load("res://scripts/yframework.gd").new()

var explosion  = preload("res://scenes/explosion.tscn")
var explosion_energy_wave  = preload("res://scenes/explosion_tst.tscn")

var wrekege_maker = load("res://scripts/wrekege_maker.gd").new()

var ship_refrence

var fireball
var fireball2
var energy_wave

var timer_counter=0
var stage=0

var rng = RandomNumberGenerator.new()

var yrange=35

var explode_times = 15

func _ready():
	
	fireball = explosion.instance()
	add_child(fireball)
	fireball.scale =Vector3(2,2,2)
	fireball2 = explosion.instance()
	add_child(fireball2)
	energy_wave = explosion_energy_wave.instance()
	energy_wave.scale =Vector3(3,3,3)
	pass 


func _process(delta):
	
	timer_counter+=delta

	#explode 10 times
	if timer_counter > 0.3 and stage<explode_times:
		effect_rnd_pos(fireball)
		fireball.explode()
		effect_rnd_pos(fireball2)
		fireball2.explode()
		stage+=1
		timer_counter=0
	#energy wave
	if timer_counter > 0.3 and stage==explode_times:
		add_child(energy_wave)
		ship_refrence.queue_free()
		create_wrackge()
		stage+=1
	if timer_counter > 3 and stage==explode_times+1:
		queue_free()
	pass
#end _process

func effect_rnd_pos(effect):
	var rnd_pos = ye.rend_3d_pos(rng,yrange) #random 3d vector
	effect.global_transform.origin = global_transform.origin+rnd_pos
	
	pass
#end effect_rnd_pos

func create_wrackge():
		if !ship_refrence.create_ship_wreck_once:
			ship_refrence.create_ship_wreck_once = true
			wrekege_maker.gen(ship_refrence,ship_refrence.ship_name)
#end create_wrackge
