extends Static_Enemy


func _ready():
	lifes = 5
	has_gravity = true

func check_view():
	$view_field.force_raycast_update()
	if $view_field.is_colliding():
		if $view_field.get_collider().name=="Player":
			$view_change.stop()
			yield(get_tree().create_timer(0.5),"timeout")
			current_state = ATTACK
	
func check_sides():
	match current_side:	
		Sides.LEFT:
			direction.x = -1
			$texture.flip_h = false
			$wall_check.cast_to.x *= -1 if sign($wall_check.cast_to.x)==1 else 1
			$ground_check.position.x *= -1 if sign($ground_check.position.x)==1 else 1
			$view_field.cast_to.x *= -1 if sign($view_field.cast_to.x)==1 else 1
			
		Sides.RIGHT:
			direction.x = 1
			$texture.flip_h = true	
			$wall_check.cast_to.x *= -1 if sign($wall_check.cast_to.x)==-1 else 1
			$ground_check.position.x *= -1 if sign($ground_check.position.x)==-1 else 1
			$view_field.cast_to.x *= -1 if sign($view_field.cast_to.x)==-1 else 1
	
func attack():
	movement.x = speed*direction.x
	if $wall_check.is_colliding():
		current_state = IDLE
		Global.get_player_camera().shake(0.3, 6)
		$view_change.start()
		
	elif !$ground_check.is_colliding():
		current_state = IDLE
		$view_change.start()


func _on_view_change_timeout():
	if current_state!=ATTACK:
		change_side()
		$view_change.wait_time = rand_range(2.5, 7)

func get_velocity():
	return movement
