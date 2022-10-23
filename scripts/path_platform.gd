extends Togglable_Object
export var speed = 120

func _ready():
	pass
	
func _physics_process(delta):
	if on:
		$path/follow/platform/animation.play("on")
		$path/follow.offset = $path/follow.offset+speed*delta
	else: 
		$path/follow/platform/animation.play("RESET")
