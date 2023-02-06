extends Node
var ye = load("res://yframework.gd").new()
var bullet = preload("res://bullet.tscn")
var that

var weapon_name ="normal"
var shot_timer = 0.2
var shot_counter = 0
var dmg = 1
var bullet_speed = 150
var team = 1

func _ready():

	pass 

func yinit(that2,fire_rate=0.2):
	that = that2
	shot_timer = fire_rate
	pass 




func can_shot_ai(delta):
	shot_counter+=delta
	if  shot_timer<=shot_counter:
		shot_counter=0
		return true
	pass
#end can_shot_ai

func can_shot(delta):
	shot_counter+=delta
	if shot_timer <= shot_counter and Input.is_action_pressed("fire") :
		shot_counter = 0 #reset firate timer
		return true
	pass 
#end can_shot

func make_bullet(gun):
	#play shot sound
	#AudioManager.play("res://assets/sfx_07b.ogg")
	var b = bullet.instance()
	that.owner.add_child(b)
	b.global_transform = gun.global_transform #put at gun pos
	b.scale =Vector3(1,1,1)#reset scale
	b.speed = bullet_speed
	b.dmg = dmg
	#b.look_at($target.global_transform.origin,Vector3.UP) #shot to target
	b.team = team #pass player team to bullet
	return b
	pass
#end make_bullet

func make_bullet_ai(gun):
	var targ = that.targ
	team = that.team
	var b = make_bullet(gun)
	b.look_at(targ.global_transform.origin+targ.velocity,Vector3.UP)
	b.team = team #pass player team to bullet
	return b


func set_weapon_stats_by_name(name):
	
	if name == "blue laser":
		pass
	
	pass
