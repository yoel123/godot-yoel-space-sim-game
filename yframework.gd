extends Node



func ymove_by(that,x,y,z):
	var move_vec = Vector3()
	move_vec.x += x
	move_vec.y += y
	move_vec.z += z
	that.move_and_slide(move_vec, Vector3(0, 1, 0))
#end ymove_by

func yrotate(that,x,y,z):
	that.rotate_y(deg2rad(y))
	that.rotate_x(deg2rad(x))
	that.rotate_z(deg2rad(z))

func hit_test(that,ytype):
	for i in that.get_slide_count():
		var collision = that.get_slide_collision(i)
		if collision.collider.is_in_group(ytype):
			return collision.collider
			
#end hit_test

func mouce_pos(that):
	return that.get_viewport().get_mouse_position()
#end mouce_pos

func ymouse_look(that,yhead,event,sens):
	if event is InputEventMouseMotion:
		that.rotate_y(deg2rad(-event.relative.x * sens))
		yhead.rotate_x(deg2rad(-event.relative.y * sens))
		yhead.rotation.x = clamp(yhead.rotation.x, deg2rad(-89), deg2rad(89))
#end mouse look


func get_object_under_mouse(that,cam,ray_len):
	var mouse_pos = that.get_viewport().get_mouse_position()
	var ray_from = cam.project_ray_origin(mouse_pos)
	var ray_to = ray_from + cam.project_ray_normal(mouse_pos) * ray_len
	var space_state = that.get_tree().root.get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection
#end get_object_under_mouse

func get_ray(that,from,to):
	var space_state = that.get_tree().root.get_world().direct_space_state
	var selection = space_state.intersect_ray(from, to)
	return selection
#end get_ray

func get_by_type(that,type):
	return that.get_parent().get_tree().get_nodes_in_group(type)

func make_timer(that,time,callback_name,ystart):
	var ytimer = Timer.new()
	ytimer.connect("timeout",that, callback_name)
	ytimer.set_wait_time(time)
	add_child(ytimer)
	if ystart:
		ytimer.start()
	return ytimer
#end make_timer

func has_att(that,att_name): return att_name in that
func yhas(that,att_name): return att_name in that
	

func deep_copy_dict(v):
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy_dict(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy_dict(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Found an object, but I don't know how to copy it!")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v
#end deeo copy dict

func rend_3d_pos(rng,yrange):
	rng.randomize()
	var ret = Vector3(rng.randi_range(-yrange,yrange),rng.randi_range(-yrange,yrange),rng.randi_range(-yrange,yrange))
	return ret	

func dist_3d(origen,target):
	var dist = origen.transform.origin.distance_to(target.global_transform.origin)
	return dist
	pass
#target is vector
func dist_3dvt(origen,target):
	var dist = origen.transform.origin.distance_to(target)
	return dist
	pass
	
func look_at_slow(that,delta,targ,rotate_speed):
	var global_transform = that.global_transform
	var T=that.global_transform.looking_at(targ.global_transform.origin, Vector3(0,1,0))
	global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, delta*rotate_speed)
	global_transform.basis.x=lerp(global_transform.basis.x, T.basis.x, delta*rotate_speed)
	global_transform.basis.z=lerp(global_transform.basis.z, T.basis.z, delta*rotate_speed)
	that.global_transform = global_transform
	pass #end look_at_slow
func look_at_slowv(that,delta,targ,rotate_speed):
	var global_transform = that.global_transform
	var T=that.global_transform.looking_at(targ, Vector3(0,1,0))
	global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, delta*rotate_speed)
	global_transform.basis.x=lerp(global_transform.basis.x, T.basis.x, delta*rotate_speed)
	global_transform.basis.z=lerp(global_transform.basis.z, T.basis.z, delta*rotate_speed)
	that.global_transform = global_transform
	pass #end look_at_slow

	
func get_scene_by_name(that,name):
	#return that.find_node_by_name(that.get_tree().get_root(),name)
	return that.get_tree().get_root().find_node(name, true, false)


################life_timer##################
class life_timer:
	var life_counter = 0
	var life_timer = 0
	
	func _init(timer):
		life_timer = timer
	
	func set_timer(timer):
		life_timer = timer
	
	func update_timer(that,delta):
		life_counter += delta
		if life_counter > life_timer:
			that.queue_free()
			return true
################end life_timer##################
