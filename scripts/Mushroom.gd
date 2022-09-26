extends KinematicBody2D

var speed = 75
var gravity = 1200
var velocity = Vector2(0,0)
var stop = false
var life = 2
var hitted = false
var move_direction = -1



func _physics_process(delta: float):
	velocity[0] = speed*move_direction
	if stop:
		velocity[0] = 0
	velocity[1] += gravity*delta
	
	velocity = move_and_slide(velocity)
	
	
	if move_direction == 1:
		$sprite.flip_h = true
	elif move_direction == -1:
		$sprite.flip_h = false
		
		
	animation_changed()
	
		
func animation_changed():
	var animation_name = "run"
	if($grounded_check.is_colliding()):
		if $wall_ray.is_colliding() or !$ground_ray.is_colliding():
			stop = true
			animation_name = "idle"
		
	if hitted:
		animation_name = "hit"
	
	#update
	if $anim.current_animation!=animation_name:
		$anim.play(animation_name)


func _on_anim_animation_finished(anim_name):
	if anim_name == "idle":
		$wall_ray.scale.x *= -1
		move_direction *= -1
		$ground_ray.position.x *=-1
		$anim.play("run")
		stop = false

func _on_hurtbox_body_entered(body):
	hitted = true
	body.speed[1] = -350
	life-=1
	get_node("hurtbox/box").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.3), "timeout")
	get_node("hurtbox/box").set_deferred("disabled", false)
	if life == 0:
		queue_free()
	hitted = false
