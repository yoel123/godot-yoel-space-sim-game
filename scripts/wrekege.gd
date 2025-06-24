extends "res://scripts/general_space_object.gd"


func _ready():
	ship_name = "wrakage"
	rotate_speed = 0.1



func _physics_process(delta):

	
	ai_movement.move_to_random_pos(self,delta,rng,40)

