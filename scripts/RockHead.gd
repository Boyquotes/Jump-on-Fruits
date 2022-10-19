extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var dashing = false

export var acceleration = 0.08
export var speed = 92
export var delay = 1.2

onready var timer = $Timer
var time_started = false
var current_target = null 
#onready var root = get_tree().get_root()
onready var damage_box = get_node("damage_box/box")
const DAMAGE_BOX_DISTANCE = 17

func _ready():
	$Timer.wait_time = delay
	for raycast in $ray_casts.get_children():
		raycast.cast_to *= $action_area/area.shape.radius
	_check_terrain()

# All move functions:

func _physics_process(delta):
	
	#procura por alvo quando não estiver em dash
	if !time_started and !dashing:
		
		for raycast in $ray_casts.get_children():
				
			if raycast.is_colliding():
					
				if raycast.get_collider().name == "Player":
					var raycast_x = sign(raycast.cast_to.x)
					var raycast_y = sign(raycast.cast_to.y)
					time_started = true
					timer.start()
					
					direction = Vector2(raycast_x, raycast_y)
					damage_box.rotation_degrees = 90 if raycast_x == 0 else 0
					damage_box.position = direction*DAMAGE_BOX_DISTANCE
					break
						
				
						
	elif dashing:	
		
		velocity = lerp(Vector2.ZERO, direction*speed, acceleration)
	
		var collision = move_and_collide(velocity)
	
		if collision:
			if collision.collider.name == "TileMap":
				$damage_box/box.disabled = true
				_check_terrain()
				get_animation(direction)
				set_collision_mask_bit(0, true)
				Global._update_nodes()
				Global.player_camera.shake(0.5, 3)
			
			if collision.collider.name == "Player":
				set_collision_mask_bit(0, false)
				
				
func _on_action_area_body_entered(body):
	if body.name == "Player":
		actives(body)

func actives(target):
	current_target = target
	$animation.play("blink_eye")
	_check_terrain()


func _on_Timer_timeout():
	dashing = true
	time_started = false
	$damage_box/box.disabled = false

func _check_terrain():
	#Checa se tem terreno dentro do alcance para colidir
	for raycast in $ray_casts.get_children():
		raycast.set_collision_mask_bit(0, false)
		raycast.force_raycast_update()
		raycast.enabled = true if raycast.is_colliding() else false
		raycast.set_collision_mask_bit(0, true)

	


#All animation handlers


func get_animation(direction):
	var new_animation = ""
	
	match direction:
		Vector2.LEFT:
			new_animation = "left"
			
		Vector2.RIGHT:
			new_animation = "right"
			
		Vector2.UP:
			new_animation = "top"
			
		Vector2.DOWN:
			new_animation = "bottom"
			
		_:
			new_animation = "active"
				
	if($animation.current_animation!=new_animation):
		$animation.play(new_animation)
		
			
func _on_animation_animation_finished(nome):
	var directionals = ["left", "right", "top", "bottom"]
	if directionals.has(nome):
		direction = Vector2.ZERO
		timer.stop()
		time_started = false
		dashing = false
		$animation.play("active")
	
	elif nome == "blink_eye":
		$animation.play("active")
		
	elif nome=="close_eye":
		$animation.play("idle")
		
	elif nome=="active":
		if current_target == null:
			$animation.play("close_eye")		

func _on_action_area_body_exited(body):
	current_target = null
	$animation.play("close_eye")
