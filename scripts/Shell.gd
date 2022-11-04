extends Patrol_Enemy


func _ready():
	lifes = 3
	attacking_unity = false
	has_gravity = true

func check_states(delta):
	match(current_state):
		PATROL:
			patrol()
		IDLE:
			movement.x = 0
		HITTED:
			pass
		DEAD:
			movement.x = 0
			has_gravity = true
			
	if has_gravity:
		apply_gravity(delta, true)
		
	movement = move_and_slide(movement)
	
func patrol():
	check_sides()
	movement.x = direction.x*speed
	if check_wall():
		current_state = IDLE
	

