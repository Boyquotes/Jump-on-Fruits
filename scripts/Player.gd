extends KinematicBody2D

var died = false
var speed = Vector2(0,0)
var up = Vector2.UP
var stop = false;
var life = 3
var max_life = 3
export var move_speed = 100
const body_gravity = 1200
var gravity = body_gravity
var jump_force = 720
var dir = 0
var grab_dir = 0
var jumps = 1
var hitted = false
var knockback_dir = 0
var knockback_int = 400
var knockback_yint = -100
var last_ground = Vector2.ZERO
var let_dust = false
var freezed = false

onready var root = get_tree().get_root()
var dust_instance = preload("res://projectiles/dust.tscn")

onready var ground_raycasts = $RayCasts_ground

signal change_life(life, max_life)

func _ready():
	if(Global.last_checkpoint!=null):
		position = Global.last_checkpoint
	connect("change_life", get_tree().get_root().get_node("Hud/main/life_holder"), "on_change_life")
	emit_signal("change_life", life, max_life)
	
func _physics_process(delta:float) -> void:
	set_animation()
	if !died:
		get_collisions()
		move_input()
	
		if !freezed:
		
			if !hitted: 
				speed[0] = lerp(speed[0], move_speed*dir, 0.2)
			else:
				speed[0] = lerp(speed[0], move_speed*knockback_dir, 0.2)
	
			apply_gravity(delta)
			speed = move_and_slide(speed, up)
	else:
		apply_gravity(delta)
		speed = move_and_slide(speed)
	#print(speed)
	
func move_input():
	if(!stop):
		dir = (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")))
	if Input.is_action_pressed("go_down") and Input.is_action_pressed("jump") and is_grounded():
		position.y +=4
		
func _input(event: InputEvent) -> void:
	if !hitted:
		if event.is_action_pressed("jump") and !Input.is_action_pressed("go_down"):
			if !grabing_wall():
				if is_grounded():
					speed[1] = -jump_force/2
					
				elif jumps>0:
					speed[1] = -jump_force/2
					jumps-=1
			else:
				speed[0] -= 200*grab_dir
				speed[1] = -jump_force/2
			
func grabing_wall():
	
	for raycast in $wall_raycasts.get_children():
		if !raycast.is_colliding():
			continue
			
		if !is_grounded():
			
			$Texture.scale.x = sign(raycast.cast_to.x)
			grab_dir = sign(raycast.cast_to.x)
			speed[1] *= 0.75
			jumps = 1
			return true
			
	return false
		
		
func set_animation():
	var current = "Idle"
	if dir!=0:
		current = "Run"
		$Texture.scale.x = dir
		
	if !is_grounded():
		current = "Jump"
		
		if speed.y>0:
			current = "Fall"
		elif jumps==0:
			current="Double_Jump"
		if grabing_wall():
			current = "wall_jump"
		
	if hitted:
		current = "Hit"
	
	if died:
		current = "dead"
	#update
	#print(current)
	
	if current == "Run" || current == "wall_jump":
		if let_dust:
			make_dust()	
			let_dust = false
	
	if $AnimationPlayer.assigned_animation!=current:
		$AnimationPlayer.play(current)
	
	
	
func is_grounded():
	for raycast in ground_raycasts.get_children():
		if raycast.is_colliding() && speed[1] == 0:
			jumps = 1
			return true
	return false
	
func apply_gravity(delta):
	speed[1] += gravity*delta

func _on_hurtbox_body_entered(body):
	var specials = ["saw", "Fallzone"]
	var immunity_frames = 1
	life-=1
	emit_signal("change_life", life, max_life)
	if life<=0:
		dies()
		return false
	hitted = true
	if specials.has(body.name) and !is_grounded() and life>0:
		respawn_after_hit(body)
		immunity_frames = 1.5
	else: 
		on_knockback(body)
	#immunity frames	
	get_node("hurtbox/shape").set_deferred("disabled", true)
	yield(get_tree().create_timer(immunity_frames),"timeout")
	get_node("hurtbox/shape").set_deferred("disabled", false)
	hitted = false
	
	
func on_knockback(colisor):
	if(colisor.has_method("get_velocity")):
		if(colisor.get_velocity().x>0):
			knockback_dir = 1
		else:
			knockback_dir = -1
		
	speed[0] = knockback_dir*knockback_int
	speed[1] = knockback_yint
	speed = move_and_slide(speed)
	

func get_collisions():
	get_node("HitBox").set_deferred("disabled", false)
	for colliders in get_slide_count():	
		var collider_obj = get_slide_collision(colliders)
		#plataforma que cai
		
		if collider_obj!=null:
			if collider_obj.collider is TileMap and is_grounded():
				last_ground = position
				
			if collider_obj.collider.has_method("collide_with"):
				collider_obj.collider.collide_with(collider_obj, self)
				
			
		
			
func dies():
	if !died:
		died = true
		speed[0] = 0
		speed[1] = -350
		get_node("HitBox").set_deferred("disabled", true)
		yield(get_tree().create_timer(3),"timeout")
		Global._reset_current()
	
func respawn_after_hit(body):
	Transition.make_transition(0)
	get_node("hurtbox/shape").set_deferred("disabled", true)
	freezed = true
	yield(get_tree().create_timer(2), "timeout")
	freezed = false
	get_node("hurtbox/shape").set_deferred("disabled", false)
	position = last_ground 
	position.x -= 20
		
func checkpoint_entered():
	Global.last_checkpoint = position
	
func make_dust():

	var dust = dust_instance.instance()
	dust.get_node("dust").emitting = true
	dust.position.x = position.x+$dust_origin.position.x*-dir
	dust.position.y = position.y+$dust_origin.position.y
	dust.scale.x = sign($Texture.scale.x)
	
	if grabing_wall():
		dust.rotation_degrees = 90
		dust.position.x = position.x+$dust_wall_origin.position.x*sign($Texture.scale.x)
		dust.position.y = position.y+$dust_wall_origin.position.y
	
	get_parent().add_child(dust)
	


func _on_dust_cooldown_timeout():
	let_dust = true
