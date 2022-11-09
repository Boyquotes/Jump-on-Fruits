extends Patrol_Enemy


func _ready():
	lifes = 1
	has_gravity = false

func check_sides():
	match current_side:	
		Sides.LEFT:
			direction.x = -1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==1 else 1
			$texture.flip_h = false
			$wind.position.x*=-1 if sign($wind.position.x)==-1 else 1
		
		Sides.RIGHT:
			direction.x = 1
			$wall_check.cast_to.x*=-1 if sign($wall_check.cast_to.x)==-1 else 1
			$texture.flip_h = true
			$wind.position.x*=-1 if sign($wind.position.x)==1 else 1
