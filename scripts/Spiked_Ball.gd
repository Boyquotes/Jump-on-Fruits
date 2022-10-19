extends Node2D

export var rotate = false
export var speed = 54
export var non_rotate_max_angle = 180
export var non_rotate_delay = 0

func _ready():
	$spike_ball.position.x = $chain_tiles.rect_size.x
	if !rotate:
		_start_tween(non_rotate_delay)

func _physics_process(delta):
	if rotate:
		if rotation_degrees>360 || rotation_degrees<-360:
			rotation_degrees = 0
		
		$spike_ball.position.x = $chain_tiles.rect_size.x
		rotation_degrees += speed*delta
	
func _start_tween(delay):
	$Tween.remove_all()
	$Tween.interpolate_property(self, "rotation_degrees", 0, non_rotate_max_angle, sqrt(speed)/10, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, delay)
	$Tween.start()
	yield($Tween,"tween_completed")
	_back_tween(delay)

func _back_tween(delay):
	$Tween.remove_all()
	$Tween.interpolate_property(self, "rotation_degrees", non_rotate_max_angle, 0, sqrt(speed)/10, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, delay)
	$Tween.start()
	yield($Tween,"tween_completed")
	_start_tween(delay)
