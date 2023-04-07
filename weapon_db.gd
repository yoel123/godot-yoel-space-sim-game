extends Node


var weapon_db = {
	"normal_laser":{"name":"normal_laser","shot_timer":0.2,"dmg":1,"bullet_speed":150,"bullet_life_timer":2,"max_ammo":50,"uses_ammo":false,"recharge_rate":0.5},
	"dumb_missile":{"name":"dumb_missile","shot_timer":0.5,"dmg":2,"bullet_speed":160,"bullet_life_timer":2,"max_ammo":200,"uses_ammo":true,"recharge_rate":0.5},
	"missile":{"name":"missile","shot_timer":1,"dmg":1,"bullet_speed":160,"bullet_life_timer":2,"max_ammo":50,"uses_ammo":true,"recharge_rate":0.5},
	"flare":{"name":"flare","shot_timer":1,"dmg":0,"bullet_speed":0,"bullet_life_timer":20,"max_ammo":5,"uses_ammo":true,"recharge_rate":0.5},
}


func set_weapon(name,weapon):
	
	var data = weapon_db[name]
	weapon.name
	weapon. weapon_name = data.name
	weapon.shot_timer = data.shot_timer
	weapon.dmg = data.dmg
	weapon.bullet_speed = data.bullet_speed
	weapon.bullet_life = data.bullet_life_timer
	weapon.uses_ammo = data.uses_ammo
	weapon.max_ammo = data.max_ammo
	weapon.ammo = data.max_ammo
	weapon.recharge_rate = data.recharge_rate

	pass
#end set_weapon
