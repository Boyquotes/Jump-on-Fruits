extends Patrol_Charge_Enemy

export var jump_force = 280

func _ready():
	lifes = 4
	has_gravity = true
	$wall_check2.cast_to.x *= direction.x
	
func start_attack():
	movement = Vector2(speed*direction.x*4, jump_force*-1)
	current_state = ATTACKING

func change_side():
	direction.x *= -1
	$view_field.cast_to*=-1
	$texture.scale.x *= -1
	$wall_check.cast_to.x*= -1
	$wall_check2.cast_to.x*= -1

func check_sides():
	if $wall_check.is_colliding() or $wall_check2.is_colliding():
			return true
	return false

func attacking():
	if movement.y==0 and $ground_check.is_colliding():
		if $view_field.is_colliding():
			current_state = PREPARING
		else:
			current_state = STOPPED
