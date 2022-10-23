extends Area2D

func _ready():
	pass


func _on_patrol_area_body_exited(body):
	if body.has_method("change_side"):
		if body.current_state!=body.DEAD:
			if body.attacking_unity == false:
				body.current_state = body.IDLE
			else:
				if body.current_state!= body.ATTACKING:
					body.current_state = body.IDLE
