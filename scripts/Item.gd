extends Area2D

func _ready():
	pass


func _on_apple_body_entered(_body):
	$animation.play("collected")


func _on_animation_animation_finished(anim_name):
	if anim_name == "collected":
		queue_free()


	
