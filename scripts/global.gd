extends Node


var missions = ["mission1","mission2"]

var current_mission = 0


var mission_brifing = [
	{"text":"mission 1 dystroy all targets","sound_file":""},
	{"text":"survive for 1 minute","sound_file":""}
	]


func next_level(that):
	#incrament current level
	current_mission +=1
	
	pass



var scenes_path = "scenes/"
var scripts_path = "scripts/"


