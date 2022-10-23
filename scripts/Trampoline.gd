extends StaticBody2D
export var power = 390
var current_rotation


func collide_with(this, player):
	$animation.play("triggered")
	$hit_area.set_deferred("disabled", true)
	var force = Vector2.ZERO
	force = global_position.direction_to($trampoline_target.global_position)
	player.speed = 0
	player.speed = power*force

func _on_animation_animation_finished(anim_name):
	if anim_name == "triggered":
		$animation.play("idle")
		$hit_area.set_deferred("disabled", false)
