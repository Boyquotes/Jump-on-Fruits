extends Enemy

class_name Static_Enemy

enum{IDLE = 2, ATTACK}

func _ready():
	current_state = IDLE
	direction = Vector2(1,0)
	
func _physics_process(delta):
	check_state(delta)
	if current_state!=DEAD:
		check_animations()

func check_state(delta):
	check_view()
	match current_state:
		DEAD:
			apply_gravity(delta, true)
		HITTED:
			movement.x = 0
		IDLE:
			check_view()
			movement.x = 0
		ATTACK:
			attack()
			
	if has_gravity:
		apply_gravity(delta, true)
	
	movement = move_and_slide(movement)

func check_view():
	pass
	
func change_side():
	pass
	
func attack():
	pass
	
func check_animations():
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
