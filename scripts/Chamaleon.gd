extends Patrol_Enemy

enum{ATTACK = 4}

func _ready():
	lifes = 3
	has_gravity = true

func _physics_process(delta):
	if $view_field.is_colliding():
		current_state = ATTACK

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
		ATTACK:
			movement.x = 0
			
	if has_gravity:
		apply_gravity(delta, true)
		
	movement = move_and_slide(movement)	

func check_sides():
	match current_side:	
		Sides.LEFT:
			direction.x = -1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==1 else 1
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==1 else 1
			$tongue/tongue_area.position.x*=-1 if sign($tongue/tongue_area.position.x)==1 else 1
			$texture.position.x = -32
			$texture.flip_h = false
		
		Sides.RIGHT:
			direction.x = 1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==-1 else 1
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==-1 else 1
			$tongue/tongue_area.position.x*=-1 if sign($tongue/tongue_area.position.x)==-1 else 1
			$texture.flip_h = true
			$texture.position.x = 3

func check_animations():
	var current = "idle" 
		
	if current_state == PATROL:
		current = "moving"
	
	if current_state==HITTED:
		current = "hit"
		
	if current_state==ATTACK:
		current = "attack"
		
	if $animation.current_animation!= current:
		$animation.play(current)

func _on_animation_animation_finished(anim_name):
	
	match anim_name:
		"attack":
			current_state = PATROL
		"hit":
			current_state = PATROL
			$hurtbox/area.set_deferred("disabled", false)
		"idle":
			current_state = PATROL
			change_side()
