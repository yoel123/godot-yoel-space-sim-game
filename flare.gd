extends KinematicBody

var is_flare = true
var team = 1
var velocity = Vector3.ZERO
var life_timer = 20
var life_counter = 0
var speed = 0

func _ready():
	add_to_group("fighter")
	pass 
#end ready

func _process(delta):
	#life timer (remove when ends)
	life_counter+=delta
	if life_counter>life_timer: queue_free()
	pass
#end _process

func _physics_process(delta):
	pass

func take_dmg(hit):
	#remove bullet
	hit.queue_free()
	#flare cant die
	pass
#end take_dmg

func move(delta):
	#if close to big ship stop
	#move
	transform.origin += -transform.basis.z * speed * delta


