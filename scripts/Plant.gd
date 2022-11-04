extends Static_Enemy

var bullet_instance = preload("res://projectiles/Bullet.tscn")
var attacked = false

func _ready():
	lifes = 6
	has_gravity = true
	
func check_view():
	check_sides()
	$view_field.force_raycast_update()
	if $view_field.is_colliding():
		if $view_field.get_collider().name=="Player":
			current_state = ATTACK
			return true
	return false

func check_sides():
	match current_side:	
		Sides.LEFT:
			direction.x = -1
			$texture.flip_h = false
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==1 else 1
			$bullet_spawn.position.x*=-1 if sign($bullet_spawn.position.x)==1 else 1
		
		Sides.RIGHT:
			direction.x = 1
			$texture.flip_h = true
			$view_field.cast_to.x*=-1 if sign($view_field.cast_to.x)==-1 else 1
			$bullet_spawn.position.x*=-1 if sign($bullet_spawn.position.x)==-1 else 1

func attack():
	if $animation.current_animation == "attack" and $animation.current_animation_position>=0.45 and !attacked:
		make_bullet()
		attacked = true
	
func make_bullet():
	var new_bullet = bullet_instance.instance()
	new_bullet.bullet_texture = preload("res://Pixel Adventure 2/Enemies/Plant/Bullet.png")
	new_bullet.piece_resource = preload("res://Pixel Adventure 2/Enemies/Plant/Bullet Pieces.png")
	new_bullet.direction = direction
	new_bullet.speed = rand_range(150,280)
	new_bullet.position = $bullet_spawn.global_position
	get_parent().add_child(new_bullet)
	
func _on_animation_animation_finished(anim_name):
	match anim_name:
		"hit":
			current_state = IDLE
		"attack":
			attacked = false
			current_state = IDLE


func _on_view_change_timeout():
	if current_state!=ATTACK:
		change_side()
		$view_change.wait_time = rand_range(2.5, 7)
