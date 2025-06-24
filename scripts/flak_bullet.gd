extends "res://scripts/bullet.gd"
var flak = preload("res://scenes/flak.tscn")

func _ready():
	$trailp.emitting = true

func did_hit(hit):
	if !hit.is_in_group("fighter") && !hit.is_in_group("player"):return #ignore other bullets
	if hit.is_in_group("hardpoint") :return
	gen_flak()
	pass
#end did_hit


func life_timer_do(): if life_counter>life_timer: gen_flak()
#end life_timer_do

func gen_flak():
	#make flack object
	var f = flak.instance()
	self.parent.add_child(f) #add to level
	f.global_transform = global_transform #put at bullet pos
	f.scale =Vector3(1,1,1)#reset scale
	f.emit()
	#remove self
	queue_free()
#end gen_flak
