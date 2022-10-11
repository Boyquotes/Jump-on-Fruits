extends KinematicBody2D

var speed = Vector2(0,0)
var up = Vector2.UP
var stop = false;
var life = 3
var move_speed = 100
var gravity = 1200
var jump_force = 720
var dir = 0
var jumps = 1
var hitted = false
var knockback_dir = 0
var knockback_int = 400
var knockback_yint = -100
onready var ground_raycasts = $RayCasts_ground

func _ready():
	pass

func _physics_process(delta:float) -> void:
	get_collisions()
	set_animation()
	move_input()
	if !hitted: 
		speed[0] = lerp(speed[0], move_speed*dir, 0.2)
	else:
		speed[0] = lerp(speed[0], move_speed*knockback_dir, 0.2)
	
	speed[1] += gravity*delta
	speed = move_and_slide(speed, up)
	
	#print(speed)
	
func move_input():
	if(!stop):
		dir = (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")))
	if Input.is_action_pressed("go_down") and Input.is_action_pressed("jump"):
		#drop-through
		pass
		
		
func _input(event: InputEvent) -> void:
	if !hitted:
		if event.is_action_pressed("jump") and !Input.is_action_pressed("go_down"):
			if is_grounded():
				speed[1] = -jump_force/2	
			elif jumps>0:
				speed[1] = -jump_force/2
				jumps-=1

			
	
		
		
func set_animation():
	var current = "Idle"
	if !is_grounded():
		current = "Jump"
		if speed.y>0:
			current = "Fall"
		elif jumps==0:
			current="Double_Jump"
		
	elif dir!=0:
		current = "Run"
		
	if dir!=0:
		$Texture.scale.x = dir
		
	if hitted:
		current = "Hit"
	#update
	#print(current)
	if $AnimationPlayer.assigned_animation!=current:
		$AnimationPlayer.play(current)
	
	
	
func is_grounded():
	for raycast in ground_raycasts.get_children():
		if raycast.is_colliding() && speed[1] == 0:
			jumps = 1
			return true
	
	return false
	


func _on_hurtbox_body_entered(body):
	life-=1
	hitted = true
	stop = true
	on_knockback(body)
	#immunity frames
	get_node("hurtbox/shape").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5),"timeout")
	get_node("hurtbox/shape").set_deferred("disabled", false)
	hitted = false
	if life<=0:
		dies()
	stop = false
func on_knockback(body):
	speed[0] = 0
	knockback_dir = dir*-1
	if knockback_dir == 0:  #player parado
		knockback_dir = body.move_direction
	speed[0] = knockback_dir*knockback_int
	#print("Knoback speed: "+String(speed))
	speed[1] = 0
	speed[1] = knockback_yint
	

func get_collisions():
	get_node("HitBox").set_deferred("disabled", false)
	for colliders in get_slide_count():	
		var collider_obj = get_slide_collision(colliders)
		
		#plataforma que cai
		if collider_obj.collider.has_method("collide_with"):
			collider_obj.collider.collide_with(collider_obj, self)
		
		#if collider_obj.collider is TileMap:
		#	var tile_pos = collider_obj.collider.world_to_map(get_node("HitBox").position)
		#	tile_pos -= collider_obj.normal
		#	var tile = collider_obj.collider.get_cellv(tile_pos)
		#	print(tile)
			
func dies():
	queue_free()
	Global._reset_current()
		
