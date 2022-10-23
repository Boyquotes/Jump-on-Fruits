extends Patrol_Enemy

class_name Patrol_Charge_Enemy

enum{
	PREPARING = 4,
	ATTACK,
	ATTACKING 
}

func _ready():
	attacking_unity = true

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
			
		PREPARING:
			movement.x = 0
			
		ATTACK:
			start_attack()
			
		ATTACKING:
			attacking()
					
	if has_gravity:
		apply_gravity(delta, true)
		
	movement = move_and_slide(movement)

func patrol():
	movement.x = direction.x*speed
	if check_sides() and current_state!=ATTACKING:
		current_state = IDLE
	check_view()

func change_side():
	direction.x *= -1
	$view_field.cast_to*=-1
	$texture.scale.x *= -1
	$wall_check.cast_to.x*= -1

func start_attack():
	movement.x = direction.x*speed*4
	current_state = ATTACKING

func attacking():
	if $wall_check.is_colliding():
		current_state = IDLE

func check_view():
	if $view_field.is_colliding():
		current_state = PREPARING
		return true

func check_animations():
	var current = "idle" 
		
	if current_state == PATROL:
		current = "moving"
		
	if get_node_or_null("ground_check")!=null:
		if movement.y>0 and !$ground_check.is_colliding():
			current = "fall"
		
	if current_state==HITTED:
		current = "hit"
		
	if current_state==PREPARING:
		current = "preparing"
	
	if current_state == ATTACKING:
		current = "attack"	
	
		
	if $animation.current_animation!= current:
		$animation.play(current)
		
func _on_animation_animation_finished(anim_name):
	
	match anim_name:
		"hit":
			current_state = PATROL
			$hurtbox/area.set_deferred("disabled", false)
		"idle":
			current_state = PATROL
			change_side()
		"preparing":
			current_state = ATTACK

