extends Node

var bullet = preload("res://bullet.tscn")
var missile = preload("res://missile.tscn")

func normal(that,gun):
	#play shot sound
	#AudioManager.play("res://assets/sfx_07b.ogg")
	var b = bullet.instance()
	that.that.owner.add_child(b) #add to level
	b.global_transform = gun.global_transform #put at gun pos
	b.scale =Vector3(1,1,1)#reset scale
	b.speed = that.bullet_speed
	b.dmg = that.dmg
	#b.look_at($target.global_transform.origin,Vector3.UP) #shot to target
	b.team = that.team #pass player team to bullet
	return b
	pass
#end normal


func guided_missile(that,gun):
	
	if !that.that.targ:return
	#get weapon owner target
	var targ = that.that.targ
	
	var m =missile.instance()
	that.that.owner.add_child(m) #add to level
	m.global_transform = gun.global_transform #put at gun pos
	m.dmg = that.dmg
	m.targ = targ
	m.team = that.team
	return m
	pass

func dumb_missile(that,gun):
	var m = guided_missile(that,gun)
	m.movment_type ="dumb_fire"
	return m

