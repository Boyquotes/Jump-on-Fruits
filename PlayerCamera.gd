extends Camera2D
var shaking = false
var dur = 0
var inten = 0
func _ready():
	pass 
	
func _process(delta):
	if shaking: shake(dur, inten)
	
func shake(duration, intensity):
	dur = duration
	inten = intensity
	shaking = true
	offset = Vector2(rand_range(0.0, intensity), rand_range(0.0,intensity))
	yield(get_tree().create_timer(duration),"timeout")
	shaking = false
