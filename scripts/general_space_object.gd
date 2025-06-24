extends KinematicBody

var ye = load("res://scripts/yframework.gd").new()
var ai_movement = load("res://scripts/ai_movement.gd").new()
var ai_combat = load("res://scripts/ai_combat.gd").new()
var bullet = preload("res://scenes/bullet.tscn")
var explosion  = preload("res://scenes/explosion.tscn")
var main_weapon = load("res://scripts/weapon.gd").new()

var ship_name = "fighter"
var rng = RandomNumberGenerator.new()

var max_hp = 50
var hp = 50

var max_shield = 200
var shield = 200
var shield_timer = 2
var shield_timer_count = 0
var shield_regen_rate = 10 #how much shield is restored each shield_timer tick

var max_speed = 35
var speed = 0
var rotate_speed = 0.5
var velocity = Vector3.ZERO

var targ_old
var targ

var rnd_targ
var rnd_targ_reached

var dead
var death_explotion_effect = "normal"
var disabled
var create_ship_wreck_once
var is_flare

var yrange =1000
var weapon_range = 300

var state ="move_random"#chase"

var trail 


export var team = 2

