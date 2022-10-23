extends Patrol_Enemy

enum{ATTACK = 4}

func _ready():
	lifes = 3
	has_gravity = true
	$view_field.cast_to.x *= direction.x

func _physics_process(delta):
	if $view_field.is_colliding():
		current_state = ATTACK

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
		ATTACK:
			movement.x = 0
			
	if has_gravity:
		apply_gravity(delta, true)
		
	movement = move_and_slide(movement)	

func change_side():
	direction.x *= -1
	$texture.scale.x *= -1
	$wall_check.cast_to.x*= -1
	$view_field.cast_to.x*=-1
	$tongue/tongue_area.position.x*=-1

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
	
	if anim_name=="attack":
		current_state = PATROL
	
	if anim_name == "hit":
		current_state = PATROL
		$hurtbox/area.set_deferred("disabled", false)
	
	if anim_name == "idle":
		current_state = PATROL
		change_side()
