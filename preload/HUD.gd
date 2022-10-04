extends CanvasLayer
var text_score 
var texture 
var reset 
func _ready():
	texture = get_node("/root/Hud/up_left/last_fruit/sprite")
	text_score = get_node("/root/Hud/up_left/score")
	reset = texture.texture
	
func _process(_delta):
	text_score.text = "Score: "+str(Global.fruits)
	
func reset_texture():
	texture.texture = reset
