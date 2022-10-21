extends Node2D
export var checked = false

func _ready():
	if Global.checkpoint_on.size()>0 and Global.checkpoint_on.has(position):
		$AnimationPlayer.play("idle")
		checked = true

func _on_AnimationPlayer_animation_finished(anim_name):
	var current = ""
	if(anim_name=="triggered"):
		current = "idle"
	
	if(current!=anim_name):
		$AnimationPlayer.play(current)


func _on_Effective_Area_body_entered(body):
	if(body.name=="Player" and !checked):
		body.checkpoint_entered(position)
		Global.checkpoint_on.append(position)
		$AnimationPlayer.play("triggered")
		checked = true
