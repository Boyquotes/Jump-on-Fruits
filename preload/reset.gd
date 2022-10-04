extends Node



func _ready():
	pass 


func _reset_all():
	Global.fruits = 0
	Global.fruits = 0
	HudScript.reset_texture()
	get_tree().reload_current_scene()
