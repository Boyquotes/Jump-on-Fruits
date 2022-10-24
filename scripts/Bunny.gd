extends Patrol_Charge_Enemy

export var jump_force = 280

func _ready():
	lifes = 4
	has_gravity = true
	$wall_check2.cast_to.x *= direction.x
	
func start_attack():
	movement = Vector2(speed*direction.x*4, jump_force*-1)
	current_state = ATTACKING

func check_sides():
	match current_side:	
		Sides.LEFT:
			direction.x = -1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==1 else 1
			$wall_check2.cast_to.x*=-1 if sign($wall_check2.cast_to.x)==1 else 1
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==1 else 1
			$texture.flip_h = false
		
		Sides.RIGHT:
			direction.x = 1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==-1 else 1
			$wall_check2.cast_to.x*=-1 if sign($wall_check2.cast_to.x)==-1 else 1
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==-1 else 1
			$texture.flip_h = true

func check_wall():
	if $wall_check.is_colliding() or $wall_check2.is_colliding():
			return true
	return false

func attacking():
	if movement.y==0 and $ground_check.is_colliding():
		if check_view():
			current_state = PREPARING
		else:
			current_state = IDLE
