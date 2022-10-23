extends Node2D
export(NodePath) var path
export var active_back = false

func _ready():
	pass


func _on_area_effect_body_entered(body):
	$AnimationPlayer.play("pressed")
	if get_node(path).has_method("actives"):
		get_node(path).actives()
		
	elif get_node(path).has_method("toggle"):
		get_node(path).toggle()


func _on_area_effect_body_exited(body):
	$AnimationPlayer.play("pressed_out")
	if active_back:
		if get_node(path).has_method("actives"):
			$AnimationPlayer.play("pressed")
			get_node(path).actives()
		elif get_node(path).has_method("toggle"):
			get_node(path).toggle()	
		


