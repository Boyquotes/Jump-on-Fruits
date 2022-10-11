extends Area2D

export var value = 1
func _ready():
	pass


func _on_fruit_body_entered(_body):
	$animation.play("collected")
	Global.fruits+=value
	get_node("/root/Hud/main/score/last_fruit/sprite").set_texture($sprite.texture)
	#print(Global.fruits)

func _on_animation_animation_finished(anim_name):
	if anim_name == "collected":
		queue_free()
