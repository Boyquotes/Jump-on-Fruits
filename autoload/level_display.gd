extends Label
var tween

func _ready():
	tween = get_node("animation")
	start_tween()
	modulate.a = 0

func _process(_delta):
	text = Global.level_name

func start_tween():
	tween.remove_all()
	tween.interpolate_property(self, "modulate:a", 0, 1, 1, tween.TRANS_LINEAR, tween.EASE_OUT, 0)
	tween.interpolate_property(self, "modulate:a", 1, 0, 1, tween.TRANS_LINEAR, tween.EASE_OUT, 4)
	tween.start()




