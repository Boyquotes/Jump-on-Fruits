extends Node2D
export(NodePath) var path

func _ready():
	pass


func _on_area_effect_body_entered(body):
	if get_node(path).has_method("actives"):
		$AnimationPlayer.play("pressed")
		get_node(path).actives()
	elif get_node(path).has_method("toggle"):
		get_node(path).toggle()


func _on_area_effect_body_exited(body):
	$AnimationPlayer.play("pressed_out")
		


