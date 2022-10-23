extends Static_Enemy

var bullet_instance = preload("res://projectiles/Plant_Bullet.tscn")
var attacked = false

func _ready():
	lifes = 6
	direction = Vector2.RIGHT
	has_gravity = true
	
func check_view():
	if $view_field.is_colliding():
		current_state = ATTACK
		return true

func attack():
	if $animation.current_animation == "attack" and $animation.current_animation_position>=0.45 and !attacked:
		make_bullet()
		attacked = true
	
	
func change_side():
	direction.x*=-1
	$bullet_spawn.position.x*=-1
	$texture.scale.x*=-1
	$view_field.cast_to.x*=-1
	
func make_bullet():
	var new_bullet = bullet_instance.instance()
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
