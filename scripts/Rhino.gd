extends Static_Enemy

var collided = false

func _ready():
	lifes = 5
	has_gravity = true


func check_view():
	$view_field.force_raycast_update()
	if $view_field.is_colliding() and current_state==IDLE:
		if $view_field.get_collider().name=="Player":
			$view_change.stop()
			if current_state!=DEAD:
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
	if !collided:
		movement.x = direction.x*speed
		$wall_check.force_raycast_update()
		
		if $wall_check.is_colliding():
			movement.y = -350
			$animation.play("hit_wall")
			Global.get_player_camera().shake(0.3, 6)
			$view_change.start()
			$pos_attack.start()
			collided = true
			
		if !$ground_check.is_colliding():
			current_state = IDLE
			$view_change.start()
	else:
		movement.x = -direction.x*40
		
	


func _on_view_change_timeout():
	if current_state!=ATTACK:
		change_side()
		$view_change.wait_time = rand_range(2.5, 7)

func get_velocity():
	if current_state == ATTACK:
		return Vector2(movement.x*4, -150)
	return movement


func _on_pos_attack_timeout():
	collided = false
	current_state = IDLE

func check_animations():
	if $animation.current_animation!="hit_wall":
		
		var current = "idle"
		
		if current_state==ATTACK:
			current = "attack"
	
		if current_state==HITTED:
			current = "hit"
	
		if current!=$animation.current_animation:
			$animation.play(current)

func _on_animation_animation_finished(anim_name):
	match anim_name:
		"hit":
			current_state = IDLE
			$view_change.start()
		"hit_wall":
			$animation.play("idle")
