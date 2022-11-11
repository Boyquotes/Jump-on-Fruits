extends KinematicBody2D

class_name Enemy

export var speed = 0

enum{DEAD, HITTED}
enum Sides{LEFT = -1, RIGHT = 1}
export(int) var current_side = Sides.LEFT
var current_state = null
var lifes = 0
var points = 10
var gravity = 1200
var has_gravity = false
var direction = Vector2.ZERO
var movement = Vector2.ZERO
#se a unidade possuí a constante ATTACKING
var attacking_unity = false



func _ready():
	$animation.playback_speed = 1.5
	pass

func apply_gravity(delta, enabled):
	if enabled:
		movement.y += gravity*delta

func take_hit():
	if current_state!=DEAD:
		if current_state!=HITTED:
			lifes -=1
			if lifes <= 0:
				dies()
				return true
			current_state = HITTED

func change_side():
	if current_side == Sides.LEFT:
		current_side = Sides.RIGHT
		
	elif current_side == Sides.RIGHT:
		current_side = Sides.LEFT

func check_sides():
	pass
	
func dies():
	current_state = DEAD
	$hitbox.set_deferred("disabled", true)
	$hurtbox/area.set_deferred("disabled", true)
	$animation.play("dead")

func check_animations():
	pass


func _on_animation_animation_finished(anim_name):
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	if current_state == DEAD: 
		Global.fruits+=points
		queue_free()

func get_velocity():
	return speed
