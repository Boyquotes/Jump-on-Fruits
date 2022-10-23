extends Enemy

class_name Patrol_Enemy
var attacking_unity = false

enum{PATROL = 2, STOPPED}


func _ready():
	direction = Vector2(1, 0)
	$texture.scale.x*=direction.x
	$wall_check.scale.x*=direction.x
	current_state = PATROL

func _physics_process(delta):
	check_states(delta)
			
	if current_state!=DEAD:
		check_animations()

func check_states(delta):
	match(current_state):
		PATROL:
			patrol()
		STOPPED:
			movement.x = 0
		HITTED:
			movement.x = 0
		DEAD:
			movement.x = 0
			has_gravity = true
			
	if has_gravity:
		apply_gravity(delta, true)
		
	movement = move_and_slide(movement)
		
func patrol():
	movement.x = direction.x*speed
	if check_sides():
		current_state = STOPPED

func change_side():
	direction.x *= -1
	$texture.scale.x *= -1
	$wall_check.cast_to.x*= -1

func check_sides():
	if $wall_check.is_colliding():
		return true
		
func take_hit():
	lifes -=1
	if lifes <= 0:
		dies()
		return true
	current_state = HITTED
	$hurtbox/area.set_deferred("disabled", true)
	
func check_animations():
	var current = "idle" 
		
	if current_state == PATROL:
		current = "moving"
	
	if current_state==HITTED:
		current = "hit"
		
		
	if $animation.current_animation!= current:
		$animation.play(current)
		
func _on_animation_animation_finished(anim_name):

	if anim_name == "hit":
		current_state = PATROL
		$hurtbox/area.set_deferred("disabled", false)
	
	if anim_name == "idle":
		current_state = PATROL
		change_side()

func get_velocity():
	return movement
