extends Patrol_Enemy
var shell = preload("res://enemies/Shell.tscn")

func _ready():
	lifes = 6
	attacking_unity = false
	has_gravity = true

func dies():
	current_state = DEAD
	var shell_instance = shell.instance()
	var random_side = int(rand_range(2,4))
	if random_side == 3:
		shell_instance.current_side = Sides.LEFT
	else:
		shell_instance.current_side = Sides.RIGHT
	shell_instance.global_position = self.global_position
	get_parent().add_child(shell_instance)
	$hitbox.set_deferred("disabled", true)
	$hurtbox/area.set_deferred("disabled", true)
	$animation.play("dead")
