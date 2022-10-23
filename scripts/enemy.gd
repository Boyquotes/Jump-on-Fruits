extends KinematicBody2D

class_name Enemy

export var speed = 0

enum{DEAD, HITTED}
var current_state = null
var lifes = 0
var gravity = 1200
var has_gravity = false
var direction = Vector2.ZERO
var movement = Vector2.ZERO




func _ready():
	pass

func apply_gravity(delta, enabled):
	if enabled:
		movement.y += gravity*delta

func take_hit():
	lifes -=1
	if lifes <= 0:
		dies()
		return true
	current_state = HITTED

func dies():
	current_state = DEAD
	$hitbox.set_deferred("disabled", true)
	$hurtbox/area.set_deferred("disabled", true)
	$animation.play("dead")

func _on_hurtbox_body_entered(body):
	if body.name=="Player" and current_state != DEAD:
		body.speed[1]=-345
		take_hit()

func check_animations():
	pass


func _on_animation_animation_finished(anim_name):
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	if current_state == DEAD: 
		queue_free()
