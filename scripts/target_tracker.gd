extends Spatial



onready var sprite = $Sprite
var current_cam #the current camera
var to2d #parent 3d position to 2d position

var screen_border_offset = Vector2( 20.0, 20.0 )

func _ready():
	pass 


func _process(delta):
	

	#get current camera
	current_cam = get_tree().get_root().get_camera()
	#if cant get current cam exit
	if not current_cam: return 
	
	#convert objects 3d point to onscreen 2d point
	to2d = current_cam.unproject_position(get_global_transform().origin)
	
	
	#get 2d screen viewport rect
	var viewport_rect = sprite.get_viewport_rect()
	
	#incase you forgot what clamp does
	#float clamp(value: float, min: float, max: float) example:clamp(100,1,50)=50 clamp(-10,1,50)=1
	
	#set sprite xy pos (limit to border offset)
	sprite.position.x = clamp(to2d.x, screen_border_offset.x, viewport_rect.size.x - screen_border_offset.x)
	sprite.position.y = clamp(to2d.y, screen_border_offset.y, viewport_rect.size.y - screen_border_offset.y)
	
	#show only when object is offscreen
	if viewport_rect.has_point(to2d):sprite.visible = false
	else:sprite.visible = true
		
	
	pass #end _process
