extends Enemy

class_name Patrol_Enemy

enum{PATROL = 2, IDLE}


func _ready():
	attacking_unity = false
	current_state = PATROL
	direction.x = 1

func _physics_process(delta):
	check_states(delta)
			
	if current_state!=DEAD:
		check_animations()
		check_sides()

func check_states(delta):
	match(current_state):
		PATROL:
			patrol()
		IDLE:
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
	check_sides()
	movement.x = direction.x*speed
	if check_wall():
		current_state = IDLE

func check_sides():
	match current_side:	
		Sides.LEFT:
			direction.x = -1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==1 else 1
			$texture.flip_h = false
		
		Sides.RIGHT:
			direction.x = 1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==-1 else 1
			$texture.flip_h = true
		
func check_wall():
	$wall_check.force_raycast_update()
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
	match anim_name:
		"hit":
			current_state = PATROL
			$hurtbox/area.set_deferred("disabled", false)
		"idle":
			change_side()
			current_state = PATROL

