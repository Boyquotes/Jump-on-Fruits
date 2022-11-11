extends Camera2D
var last_intensity = 0

func _ready():
	pass
	
func _process(delta):
	pass
	
func shake(duration, intensity):
	if($trans_tween.is_active() and intensity>last_intensity):
		$trans_tween.remove_all()
	var count = 0
	last_intensity = intensity
	while(count<duration):
		$trans_tween.interpolate_property(self, "offset", offset, Vector2(offset.x+rand_range(-intensity, intensity), offset.y+rand_range(-intensity, intensity)), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, count)
		count+=0.1
	$trans_tween.start()


func _on_trans_tween_tween_all_completed():
	offset = Vector2.ZERO
