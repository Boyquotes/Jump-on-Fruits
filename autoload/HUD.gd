extends CanvasLayer
onready var text_score = get_node("/root/Hud/main/score/score")
onready var texture = get_node("/root/Hud/main/score/last_fruit/sprite")
onready var this_clock = get_node("/root/Hud/main/timer/Timer")
var text_max_length = 7
var reset 

func _ready():
	reset = texture.texture
	this_clock.start()
	
func _process(_delta):
	var text = text_score.text
	text = "000000"+str(Global.fruits)
	while(text.length()>7):
		text[text.find("0")] = "" 
	text_score.text = text

func reset_procedures(reload):
	Global._update_nodes()
	reset_texture()
	reset_timer()
	reset_lifes()
	if !reload:
		reset_title()
	
func reset_texture():
	texture.texture = reset

func reset_timer():
	this_clock.now_seconds = this_clock.limit_seconds
	this_clock.clock_end()

func reset_title():
	var title = get_node("/root/Hud/level_title/text")
	title.start_tween()

func reset_lifes():
	var lifes = get_node("/root/Hud/main/life_holder")
	lifes._reset_scale()

