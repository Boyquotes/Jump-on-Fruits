extends Static_Enemy


func _ready():
	lifes = 5
	has_gravity = true
	direction = Vector2(1,0)
	
func change_side():
	$wall_check.cast_to.x*=-1
	$view_field.cast_to.x*=-1
	$texture.scale.x*=-1
	direction.x*=-1	

func check_view():
	if $view_field.is_colliding():
		yield(get_tree().create_timer(1), "timeout")
		current_state = ATTACK
	
func attack():
	movement.x = speed*direction.x
	if $wall_check.is_colliding():
		current_state = IDLE
		Global.get_player_camera().shake(0.3, 6)
		yield(get_tree().create_timer(4), "timeout")
		change_side()

