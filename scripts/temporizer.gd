extends Node
export(float) var seconds  = 1
export var on = true

func _ready():
	$Timer.wait_time = seconds
	


func _on_Timer_timeout():
	if on:
		for child in get_children():
			if child.has_method("toggle"):
				child.toggle()
				
func toggle():
	on = !on
