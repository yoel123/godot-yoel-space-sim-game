extends KinematicBody

var ye = load("res://scripts/yframework.gd").new()
var bullet = preload("res://scenes/bullet.tscn")
var main_weapon = load("res://scripts/weapon.gd").new()
var secondery_weapon = load("res://scripts/weapon.gd").new()
var flare_luncher = load("res://scripts/weapon.gd").new()
var ai_movement = load("res://scripts/ai_movement.gd").new()
var ai_combat = load("res://scripts/ai_combat.gd").new()


#how is the plane/ship controlled
var yinput_control = "keyboard"#"mouse" #or keyboard

#input response or ship manuverabilety and speed
export var max_speed_normal = 50
export var max_speed_boost = 60
export var acceleration = 2.3
export var pitch_speed = 1.5
export var roll_speed = 1.9
export var yaw_speed = 0.75
var max_speed_current = 50
var max_yaw = 70
var max_roll = 70
var input_response = 8.0

#guns
var dmg = 1

# boost
var boost_avail = 0.1
var boost_usage_rate = 0.5
var boost_regen_rate = 0.3
var shake_power = 0.03

#ship rotation and movment vars
var velocity = Vector3.ZERO
var forward_speed = 10
var pitch_input = 0
var roll_input = 0
var yaw_input = 0

onready var cam = $Camera

var team = 1

var targ

onready var trail = $trails.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")
	main_weapon.that = self#pass this obj refrence to weapon
	#main_weapon.weapon_name ="missile"
	
	secondery_weapon.set_weapon_stats_by_name("dumb_missile")
	secondery_weapon.that = self
	flare_luncher.set_weapon_stats_by_name("flare")
	flare_luncher.that = self
	pass # Replace with function body.

func _process(delta):
	point_to_target() 
	trail.trails_handle(self,forward_speed)
	main_weapon.update(delta)
	pass

func _physics_process(delta):
	get_input(delta)
	
	velocity = -transform.basis.z * forward_speed
	move_and_collide(velocity * delta)
	boost_handle(delta)
#end _physics_process


func get_input(delta):
	
	#call input controll
	if yinput_control =="mouse":
		mouse_movement(delta)
	if yinput_control =="keyboard":
		keyboard_movment(delta)

	#accelerate and decelerate
	if Input.is_action_pressed("throttle_up"):
		forward_speed = lerp(forward_speed, max_speed_current, acceleration * delta)
	if Input.is_action_pressed("throttle_down"):
		forward_speed = lerp(forward_speed, 0, acceleration * delta)
		#forward_speed = lerp(forward_speed, -max_speed, acceleration * delta)
	
	#compare target speed
	if Input.is_action_pressed("match_speed") && is_instance_valid(targ):
		forward_speed = targ.speed
		if forward_speed > max_speed_normal:forward_speed = max_speed_normal
	
	shot(delta)
	
	# If camera toggle pressed once (to avoid repeat presses) 
	if Input.is_action_just_pressed("camera_toggle"):
		if ($Camera_Ext.current):
			$Camera_Pilot.current = true
		else:
			$Camera_Ext.current = true
	
	if (Input.is_action_pressed("boost") && (boost_avail > 0)):
		forward_speed = max_speed_boost
		max_speed_current = max_speed_boost
		boost_avail -= boost_usage_rate * delta

		if boost_avail>0:
			$Camera_Ext.add_trauma(shake_power)
			$Camera_Pilot.add_trauma(shake_power)


	else:
		max_speed_current = max_speed_normal
	
#end get_input
	
func take_dmg(hit):
	#remove bullet
	#hit.queue_free()

	pass
#end take_dmg

func shot(delta):
	
	#shot
	if main_weapon.can_shot(delta,"fire"):
		#shot all guns
		for gun in $guns.get_children():
			#create shot
			main_weapon.make_bullet(gun)
		pass
	pass
	
	#shot secondery
	if secondery_weapon.can_shot(delta,"secondery_fire"):
		#shot all guns
		for gun in $guns2.get_children():
			#create shot
			secondery_weapon.make_bullet(gun)
		pass
	pass
	
	if flare_luncher.can_shot(delta,"shot_flare"):
		flare_luncher.make_bullet($flare_lunch_pos)
		pass
	pass
#end shot	

func keyboard_movment(delta):
	
	#get input
		
	#turn ship up down
	
	pitch_input = lerp(pitch_input, 
			Input.get_action_strength("pitch_down") - Input.get_action_strength("pitch_up"),
			input_response * delta)
	
	
	#turn ship left right
	
	roll_input = lerp(roll_input,
			Input.get_action_strength("roll_left") - Input.get_action_strength("roll_right"),
			input_response * delta)
	

	#do input
			
	#pitch
	transform.basis = transform.basis.rotated(ynormalize( transform.basis.x), pitch_input * pitch_speed * delta)

	#roll
	transform.basis = transform.basis.rotated( ynormalize(transform.basis.y), roll_input * roll_speed * delta)
	
	pass
#end keyboard_movment	

func mouse_movement(delta):

	var mouse_speed = _get_mouse_speed()
	var amount = abs(mouse_speed.x)
	var direction = sign(mouse_speed.x)
	
	#pitch
	var mpitch_speed = pitch_speed*110 #mouse pitch
#	rotation_degrees.x += mouse_speed.y * delta * mpitch_speed

	#yaw
#	rotation_degrees.y += mouse_speed.x * delta * mpitch_speed
	#rotation_degrees.y = lerp(0, max_yaw, amount) * direction
	#rotation_degrees.z = lerp(0, max_roll, amount) * direction
	#limit vertical rotation
	#if rotation_degrees.x>=90:rotation_degrees.x=90
	#if rotation_degrees.x<=-90:rotation_degrees.x=-90
	#print(rotation_degrees.x," ",rotation_degrees.y)

	pass
#end  mouse_movement


func point_to_target() :
	
	var enemies = ai_combat.get_fighters(self)
	if enemies.size()>0 :
		$target2/tri.visible = true
		$target2.look_at(enemies[0].global_transform.origin,Vector3.UP)
		#set target
		targ = enemies[0]
	else:
		$target2/tri.visible = false
	
	#look at target
	if targ && is_instance_valid(targ):
		$target2.look_at(targ.global_transform.origin,Vector3.UP)
	else:
		$target2/tri.visible = false
		
	pass #end  point_to_target


func get_throttle(): return float(forward_speed / max_speed_normal * 100)

func boost_handle(delta):
	# Clamp boost from 0 to 1
	boost_avail = clamp(boost_avail, 0, 1)
	
	# Regenerate boost over time
	boost_avail += boost_regen_rate * delta
#end boost_handle

func _get_mouse_speed() -> Vector2:
	
	var screen_center = get_viewport().size * 0.5
	var displacment = screen_center - get_viewport().get_mouse_position()
	displacment.x /= screen_center.x
	displacment.y /= screen_center.y
	#get_viewport().warp_mouse(get_viewport().size / 2.0)
	return displacment	
	

func ynormalize( vec:Vector3 ):
	var newVec = vec.normalized()
	if is_zero_approx(newVec.length()): #< 1:
		newVec  = Vector3.UP #or whatever is your default
	return newVec



