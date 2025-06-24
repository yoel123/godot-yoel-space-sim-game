extends Node
var ye = load("res://scripts/yframework.gd").new()

var  wrekege1 = preload("res://scenes/wrekege1.tscn")
var  wrekege2 = preload("res://scenes/wrekege2.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	pass

func single_wrack(that,w):
	that.owner.add_child(w) #add to level
	w.global_transform = that.global_transform #put at gun pos
	w.scale =Vector3(1,1,1)#reset scale
	return w
#end single_wrack

func random_pos(w,yrange):
	var rnd_pos = ye.rend_3d_pos(rng,yrange)
	w.global_transform.origin += rnd_pos
#end random_pos		

func gen(that,name):
	if name =="heavy_shuttle":
		var w = wrekege1.instance()
		var w2 = wrekege2.instance()
		single_wrack(that,w)
		single_wrack(that,w2)
		random_pos(w,15)
		random_pos(w2,15)
#end gen


