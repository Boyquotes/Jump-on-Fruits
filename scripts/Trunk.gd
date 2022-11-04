extends Patrol_Enemy
var bullet_instance = preload("res://projectiles/Bullet.tscn")
var attacked = false
enum{ATTACK = 4}

func _ready():
	lifes = 4
	has_gravity = true
	attacking_unity = false

func check_states(delta):
	check_view()
	match(current_state):
		PATROL:
			patrol()
		IDLE:
			movement.x = 0
		HITTED:
			movement.x = 0
		ATTACK:
			movement.x = 0
			attack()
		DEAD:
			movement.x = 0
			has_gravity = true	
	if has_gravity:
		apply_gravity(delta, true)
		
	movement = move_and_slide(movement)

func check_view():
	check_sides()
	$view_field.force_raycast_update()
	if $view_field.is_colliding():
		if $view_field.get_collider().name=="Player":
			current_state = ATTACK
			return true
	return false

func attack():
	if $animation.current_animation == "attack" and $animation.current_animation_position>=0.7 and !attacked:
		make_bullet()
		attacked = true
		
func make_bullet():
	var new_bullet = bullet_instance.instance()
	new_bullet.bullet_texture = preload("res://Pixel Adventure 2/Enemies/Trunk/Bullet.png")
	new_bullet.piece_resource = preload("res://Pixel Adventure 2/Enemies/Trunk/Bullet Pieces.png")
	new_bullet.direction = direction
	new_bullet.speed = rand_range(150,280)
	new_bullet.get_node("Sprite").flip_h = true if current_side==Sides.RIGHT else false
	new_bullet.position = $bullet_spawn.global_position
	get_parent().add_child(new_bullet)

func check_sides():
	match current_side:	
		Sides.LEFT:
			direction.x = -1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==1 else 1
			$texture.flip_h = false
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==1 else 1
			$bullet_spawn.position.x*=-1 if sign($bullet_spawn.position.x)==1 else 1
		
		Sides.RIGHT:
			direction.x = 1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==-1 else 1
			$texture.flip_h = true
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==-1 else 1
			$bullet_spawn.position.x*=-1 if sign($bullet_spawn.position.x)==-1 else 1
	

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
		"hit":
			current_state = PATROL
			$hurtbox/area.set_deferred("disabled", false)
		"idle":
			change_side()
			current_state = PATROL
		"attack":
			attacked = false
			current_state = PATROL
