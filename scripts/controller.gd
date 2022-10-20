extends "res://scripts/Interactive_Trap.gd"

func _ready():
	pass
	


func actives():
	if on:
		for child in get_children():
			if child.has_method("toggle"):
				child.toggle()
