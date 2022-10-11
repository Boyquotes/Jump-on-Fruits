extends Timer

class_name Clock

export var limit_seconds = 45
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
		self.stop()
		yield(get_tree().create_timer(1),"timeout")
		self.start()
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
					get_node("/root/level0/Player/MainCamera").shake(0.5, 1.7)
					clock.set("custom_colors/font_color", red)
				else:
					clock.set("custom_colors/font_color", white)
			else:
				if(seconds%2==0):
					clock.set("custom_colors/font_color", red)
				else:
					clock.set("custom_colors/font_color", white)

func clock_end():
	now_seconds = limit_seconds+1
	clock.set("custom_colors/font_color", white)
	
	

