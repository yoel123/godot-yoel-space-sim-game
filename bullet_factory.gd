extends Node

var bullet = preload("res://bullet.tscn")
var missile = preload("res://missile.tscn")
var flare = preload("res://flare.tscn")

func normal(that,gun):
	#play shot sound
	#AudioManager.play("res://assets/sfx_07b.ogg")
	var b = bullet.instance()
	that.that.owner.add_child(b) #add to level
	b.global_transform = gun.global_transform #put at gun pos
	b.scale =Vector3(1,1,1)#reset scale
	b.speed = that.bullet_speed
	b.dmg = that.dmg
	b.life_timer = that.bullet_life
	#b.look_at($target.global_transform.origin,Vector3.UP) #shot to target
	b.team = that.team #pass player team to bullet
	b.parent = that.that
	return b
	pass
#end normal


func guided_missile(that,gun):
	
	#that is the weapon, that.that is the weapons parent 

	var m =missile.instance()
	that.that.get_tree().get_root().add_child(m) #add to level
	m.global_transform = gun.global_transform #put at gun pos
	m.dmg = that.dmg
	m.life_timer = that.bullet_life
	m.team = that.team
	m.scale =Vector3(1,1,1)#reset scale
	
	#get weapon owner target
	if that.that.targ:m.targ = that.that.targ
	
	
	return m
	pass

func dumb_missile(that,gun):
	var m = guided_missile(that,gun)
	m.movment_type ="dumb_fire"
	return m
#end dumb_missile

func flare(that,gun):
	var b = flare.instance()
	that.that.owner.add_child(b) #add to level
	b.global_transform = gun.global_transform #put at gun pos
	b.scale =Vector3(1,1,1)#reset scale
	b.speed = that.bullet_speed 
	b.life_timer = that.bullet_life
	#b.look_at($target.global_transform.origin,Vector3.UP) #shot to target
	b.team = that.team #pass player team to bullet
	return b
	pass
#end flare
