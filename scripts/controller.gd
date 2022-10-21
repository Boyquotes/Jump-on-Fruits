extends Node

func _ready():
	pass
	


func actives():
		for child in get_children():
			if child.has_method("toggle"):
				child.toggle()
