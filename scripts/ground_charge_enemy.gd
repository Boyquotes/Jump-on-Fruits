extends Patrol_Enemy

class_name Patrol_Charge_Enemy

enum{
	PREPARING = 4,
	ATTACK,
	ATTACKING 
}

func _ready():
	attacking_unity = true
	
func _physics_process(delta):
	match current_state:
		
		PATROL:
			patrol()
			
		ATTACK:
			start_attack()
			
		ATTACKING:
			attacking()
			
		PREPARING:
			movement.x = 0
			

func patrol():
	movement.x = direction.x*speed
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
	if movement.y==0 and $ground_check.is_colliding():
			if !check_view():
				current_state = STOPPED
			else:
				current_state = PREPARING

func check_view():
	if $view_field.is_colliding():
		current_state = PREPARING
		return true

func check_animations():
	var current = "idle" 
		
	if current_state == PATROL:
		current = "moving"
		
	if movement.y>0 and !$ground_check.is_colliding():
		current = "fall"
		
	if current_state==HITTED:
		current = "hit"
		
	if check_sides() and current_state!=ATTACKING:
		current_state = STOPPED
		
	if current_state==PREPARING:
		current = "preparing"
	
	if current_state == ATTACKING:
		current = "jump"	
	
		
	if $animation.current_animation!= current:
		$animation.play(current)
		
func _on_animation_animation_finished(anim_name):

	if anim_name == "hit":
		current_state = PATROL
		$hurtbox/area.set_deferred("disabled", false)
	
	if anim_name == "idle":
		current_state = PATROL
		change_side()
	
	if anim_name == "preparing":
		current_state = ATTACK

