extends Node
var fruits = 0
func _ready():
	pass 

func _reset_current():
	Hud.reset_texture()
	Hud.reset_timer()
	fruits = 0
	get_tree().reload_current_scene()
