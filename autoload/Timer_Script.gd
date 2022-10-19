extends Timer

class_name Clock

export var limit_seconds = 345
var now_seconds = limit_seconds
var red = Color(255,0,0)
var white = Color(255,255,255)
onready var clock = get_node("/root/Hud/main/timer/clock")

func _ready():
	var minutes = int(now_seconds/60)
	clock.text = _clock_text(now_seconds-minutes*60, minutes)
	
func _on_Timer_timeout():
	now_seconds-=1
	var minutes = int(now_seconds/60)
	var seconds = now_seconds-minutes*60
	_clock_animation(seconds, minutes)
	clock.text = _clock_text(seconds, minutes)
	
	if(now_seconds==0):
		stop()
		yield(get_tree().create_timer(3),"timeout")
		Global._reset_current()

func _clock_text(seconds, minutes):
	
	var minutes_text = ""
	var seconds_text = ""
	if(minutes<10):
		minutes_text = "0"+str(minutes)
	else:
		minutes_text = str(minutes)
	if(seconds<10):
		seconds_text = "0"+str(seconds)
	else:
		seconds_text = str(seconds)
		
	return minutes_text+":"+seconds_text
		
func _clock_animation(seconds, minutes):
		if (minutes<1):
			if(seconds>=16 or seconds == 0):
				if(seconds%10==0):
					if(!is_instance_valid(Global.player_camera)):
						Global._update_nodes()
					Global.player_camera.shake(0.5, 1.7)
					clock.set("custom_colors/font_color", red)
				else:
					clock.set("custom_colors/font_color", white)
			else:
				if(seconds%2==0):
					clock.set("custom_colors/font_color", red)
				else:
					clock.set("custom_colors/font_color", white)

func clock_end():
	now_seconds = limit_seconds
	clock.set("custom_colors/font_color", white)
	start()
	
	

