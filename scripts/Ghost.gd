extends Static_Enemy


enum {APPEAR=4, DESAPPEAR}

onready var cap_speed = speed
var target = null
var attack_started = false

func _ready():
	lifes = 4
	has_gravity = false

func check_state(delta):
	check_sides()
	match current_state:
		DEAD:
			apply_gravity(delta, true)
		HITTED:
			movement = Vector2.ZERO
		IDLE:
			movement = Vector2.ZERO
		ATTACK:
			attack()
			
	if has_gravity:
		apply_gravity(delta, true)
	
	movement = move_and_slide(movement)

func attack():
	
	if target.global_position.x>global_position.x:
		current_side = Sides.LEFT
	else: 
		current_side = Sides.RIGHT
	
	if speed>0:
		movement = direction*speed
		speed -= 5
	else:
		$hurtbox.set_deferred("monitoring", true)
		$hitbox.set_deferred("disabled", true)
		current_state = IDLE
		$cooldown.start()
		
func check_sides():
	match current_side:	
		Sides.LEFT:
			$texture.flip_h = false
		
		Sides.RIGHT:
			$texture.flip_h = true
		
func check_animations():
	var current = "idle"
	
	if current_state==ATTACK:
		current = "attack"
	
	if current_state==HITTED:
		current = "hit"
	
	if current_state==DESAPPEAR:
		current = "desappear"
		
	if current_state==APPEAR:
		current = "appear"
		
	if current!=$animation.current_animation:
		$animation.play(current)

func _on_animation_animation_finished(anim_name):
	match anim_name:
		"hit":
			current_state = IDLE
		"desappear":
			$hitbox.set_deferred("disabled", true)
			$hurtbox.set_deferred("monitoring", false)
			$action_area.set_deferred("monitoring", false)
			$wait.wait_time = rand_range(4,21)
			visible = false
			$wait.start()
			current_state = IDLE
		"appear":
			$hitbox.set_deferred("disabled", false)
			current_state = ATTACK

func _on_action_area_body_entered(body):
	if body.name=="Player":
		target = body
		current_state = DESAPPEAR

func _on_wait_timeout():
	
	var new_position = Vector2.ZERO
	new_position = Vector2(rand_range(target.global_position.x-100,target.global_position.x+100),rand_range(target.global_position.y-100,target.global_position.y+100))
	if new_position.distance_to(target.global_position)<40:
		if target.global_position.x>new_position.x:
			new_position.x -= rand_range(30,50)
			
		else: 
			new_position.x += rand_range(30,50)
			
		if target.global_position.y>new_position.y:
			new_position.y -= rand_range(30,50)
			
		else: 
			new_position.y += rand_range(30,50)
			
	global_position = new_position
	visible = true
	direction = global_position.direction_to(target.global_position)
	scale.x *= sign(direction.x)
	current_state = APPEAR


func _on_cooldown_timeout():
	speed = cap_speed
	$hitbox.set_deferred("disabled", false)
	$action_area.set_deferred("monitoring", true)



