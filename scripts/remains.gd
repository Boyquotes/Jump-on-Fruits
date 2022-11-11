extends RigidBody2D

func _ready():
	weight = 11.3
	pass



func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"alive_time":
			queue_free()
