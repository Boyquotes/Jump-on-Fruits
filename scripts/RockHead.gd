extends KinematicBody2D

enum Directions{LEFT, RIGHT, UP, DOWN}
export(Array, int) var pattern = [Directions.RIGHT, Directions.DOWN, Directions.LEFT, Directions.UP]
export(float) var speed = 250
var visible_screen = false
var bodies = []
var cooldown = 2
var direction
var dir = Vector2.ZERO 
var movement = Vector2.ZERO
var current_index
var current_animation = "blink_eye"
var stopped = false

func _ready():
	current_index = 0
	cooldown = speed/(speed*2)
	$animation.playback_speed = speed/100
	direction = pattern[current_index]
	$Timer.wait_time = cooldown

func _physics_process(delta):
	check_direction()
	if !stopped:
		movement = lerp(Vector2.ZERO, dir*speed, 0.05)
		movement = move_and_collide(movement)
		
		if movement:
			stopped = true
			if visible_screen:
				Global.get_player_camera().shake(0.2, 5)
					
			collide_animation()
			$Timer.start()
	
func check_direction():
	match(direction):
		Directions.LEFT:
			dir = Vector2.LEFT
			current_animation = "left"
			$damage_area.rotation_degrees = 270
			
		Directions.RIGHT:
			dir = Vector2.RIGHT
			current_animation = "right"
			$damage_area.rotation_degrees = 90
			
		Directions.UP:
			dir = Vector2.UP
			current_animation = "top"
			$damage_area.rotation_degrees = 0
			
		Directions.DOWN:
			dir = Vector2.DOWN
			current_animation = "bottom"
			$damage_area.rotation_degrees = 180

func collide_animation():
	if current_animation!= $animation.current_animation:
		$animation.play(current_animation)
	
func get_velocity():
	return dir*800

func _on_animation_animation_finished(animation):
	match(animation):
		"blink_eye":
			$animation.play("active")
			
		"close_eye":
			$animation.play("idle")
			
		_:
			$animation.play("active")
		
func _on_Timer_timeout():
	stopped = false
	var next_target = current_index+1 if current_index+1<pattern.size() else 0
	current_index = next_target
	direction = pattern[next_target]


func _on_VisibilityNotifier2D_screen_entered():
	visible_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	visible_screen = false


func _on_damage_area_body_entered(body):
	bodies.append(body)
	var wall = false
	var player = false
	for corpo in bodies:
		if corpo is TileMap:
			wall = true
			continue
		if corpo is KinematicBody2D:
			if corpo.get_collision_layer_bit(0):
				player = true
				continue
	if wall and player:	
		$rock_head.set_collision_mask_bit(5, true)


func _on_damage_area_body_exited(body):
	bodies.remove(bodies.find(body))
	$rock_head.set_collision_mask_bit(5, false)
