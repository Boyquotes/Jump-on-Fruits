extends Area2D
export var jump_power = 420
var body_in_area = null

func _ready():
	pass

func _process(delta):
	if body_in_area!=null and Input.is_action_just_pressed("jump"):
		body_in_area.speed.y = -jump_power
		body_in_area.jumps = 1
		$emitter.emitting = true
		$AnimationPlayer.play("hit")

func _on_jump_boost_body_entered(body):
	if body.name == "Player":
		body_in_area = body


func _on_jump_boost_body_exited(body):
	if body.name == "Player":
		body_in_area = null


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"hit":
			monitoring = false
			$cooldown.start()
			
		"respawn":
			monitoring = true
			$AnimationPlayer.play("idle")
			


func _on_cooldown_timeout():
	$AnimationPlayer.play("respawn")
