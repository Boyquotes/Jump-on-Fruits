extends Node2D

onready var platform = $Platform
onready var tween = $Tween

export var speed = 3.0
export var horizontal = true
export var rotational = false
export var reverse_rotational = false
export var distance = 192
var follow = Vector2.ZERO
var sum_delta = 0
var this_delta = null
const WAIT_DURATION = 1.0


func _ready():
	if(!rotational):
		_start_tween() 
	
func _start_tween():
	var move_direction = Vector2.RIGHT*distance if horizontal else Vector2.UP*distance	
	var duration = move_direction.length()/float(speed*16)
	tween.interpolate_property(self, "follow", 
		Vector2.ZERO, move_direction, duration, 
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, WAIT_DURATION)
	tween.interpolate_property(self, "follow", 
		move_direction, Vector2.ZERO, duration, 
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, duration+WAIT_DURATION*2)
	tween.start()
	
	
func _physics_process(delta):
	if(rotational):
		if reverse_rotational:
			sum_delta-=delta
		else:
			sum_delta+= delta
		follow = Vector2(
			#distance = raio
			sin(sum_delta*speed)*distance,
			cos(sum_delta*speed)*distance
		)
	platform.position = platform.position.linear_interpolate(follow, 0.05)
		
