extends KinematicBody2D

enum {DEAD, IDLE, MOVING, JUMP, HIT, GRAB, FALLING}
enum PhyState{FREEZED, FREE, STOPPED}
enum Side{LEFT, RIGHT}
var current_state = IDLE
var phy_state = PhyState.FREE
var knockback_dir = Vector2(1,1)
export var current_side = Side.RIGHT
var wall_jumped = false
var died = false
var speed = Vector2(0,0)
var has_gravity = true
var up = Vector2.UP
var max_life = 4
var life = max_life
onready var first_spawn = position
export var move_speed = 100
const body_gravity = 1200
var gravity = body_gravity
var jump_force = 720
var dir = 0
var max_jumps = 2
var jumps = max_jumps
var last_dir = 1
var ragdoll_spawned = null
var last_ground = null
var let_dust = false
var freezed = false
var can_grab = true
onready var root = get_tree().get_root()
var ragdoll_instance = preload("res://items/Player_Ragdoll.tscn")
var dust_instance = preload("res://projectiles/dust.tscn")
signal change_life(life, max_life)

func _ready():
	$ProgressBar.max_value = $wall_time.wait_time
	if(Global.last_checkpoint!=null):
		position = Global.last_checkpoint
	connect("change_life", get_tree().get_root().get_node("Hud/main/life_holder"), "on_change_life")
	emit_signal("change_life", life, max_life)
	
func _physics_process(delta:float) -> void:
	check_sides()
	check_states(current_state)
	set_animation()
	if current_state!=DEAD:
		get_collisions()
		move_input()
	
		if phy_state!=PhyState.FREEZED:
			speed[0] = lerp(speed[0], move_speed*dir, 0.2)
		else:
			speed = Vector2.ZERO
	
	if has_gravity:
		apply_gravity(delta)	
	
	speed = move_and_slide(speed, up)
	#print(speed)

func check_sides():
	match(current_side):
		Side.LEFT:
			$Texture.scale.x *= -1 if sign($Texture.scale.x) == 1 else 1
			$wall_raycast.cast_to.x*=-1 if sign($wall_raycast.cast_to.x) == 1 else 1
		Side.RIGHT:
			$Texture.scale.x *= -1 if sign($Texture.scale.x) == -1 else 1
			$wall_raycast.cast_to.x*=-1 if sign($wall_raycast.cast_to.x) == -1 else 1

func check_states(state):
	match(state):
		DEAD:
			phy_state = PhyState.FREEZED
			has_gravity = false
			speed = Vector2.ZERO
		IDLE:
			pass
			
		MOVING:
			pass
			
		JUMP:
			jump()
			
		HIT: 
			phy_state = PhyState.STOPPED
			
		GRAB:
			slide_wall()
			
		FALLING: 
			if speed[1]<0:
				current_state = JUMP
			
				
func move_input():
	$ProgressBar.value = $wall_time.time_left
	if(phy_state==PhyState.FREE):
		dir = (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")))
		if dir!=0:
			match(dir):
				1:
					current_side = Side.RIGHT
				-1:
					current_side = Side.LEFT
			last_dir = dir
			
		if is_grounded():
			current_state = MOVING if dir!=0 else IDLE
			
		if Input.is_action_pressed("go_down") and Input.is_action_just_pressed("jump") and is_grounded():
			position.y +=2
		
		if Input.is_action_just_pressed("jump") and !Input.is_action_pressed("go_down"):
			current_state = JUMP

func jump():
	if !in_wall():
		if jumps>0:
			if is_grounded():
				speed[1] = -jump_force/2
				jumps-=1
					
			else:
				make_dust()
				speed[1] = -jump_force/2
				$AnimationPlayer.play("Double_Jump")
				jumps = 0
	else:
		wall_jumped = true
		speed[0] -= 400*$Texture.scale.x
		speed[1] = -jump_force/2		
			
func in_wall():
	if !is_on_floor() and is_on_wall() and can_grab and $wall_raycast.is_colliding() and current_state!=HIT and phy_state == PhyState.FREE:
		jumps = 1
		$ProgressBar.visible = true
		current_state = GRAB
		return true
	
	wall_jumped = false
	has_gravity = true
	$ProgressBar.visible = false
	if !$wall_time.is_stopped():
		$wall_time.paused = true
	
	return false

func slide_wall():
	
	if $wall_time.is_stopped():
		$wall_time.start()
		
	else:
		$wall_time.paused = false
				
	if $wall_time.time_left>$wall_time.wait_time/2:
		has_gravity = false
		if !wall_jumped:
			speed[1] = 0
		
	else:
		has_gravity = true
		speed[1] *= 1/$wall_time.time_left if $wall_time.time_left>=1 else 1
		
		
func set_animation():
	var asign_animation = "Idle"
	
	if current_state == MOVING:
		asign_animation = "Run"
		
	if $AnimationPlayer.current_animation!="Double_Jump":
		if current_state==FALLING:
			asign_animation = "Fall"
			
		if current_state == JUMP:
			asign_animation = "Jump"
	else: 
		asign_animation = "Double_Jump"
	
	if current_state == GRAB:
		asign_animation = "wall_jump"
		
	if current_state == HIT:
		phy_state = PhyState.STOPPED
		asign_animation = "Hit"
	
	if current_state == DEAD:
		asign_animation = "dead"
	
	if asign_animation == "Run" || asign_animation == "wall_jump":
		if let_dust:
			make_dust()	
			let_dust = false
	
	if $AnimationPlayer.current_animation!=asign_animation:
		$AnimationPlayer.play(asign_animation)
	
	
	
func is_grounded():
	if is_on_floor():
		current_state = IDLE
		jumps = max_jumps
		$wall_time.stop()
		can_grab = true
		return true
		
	if !in_wall():
		current_state = FALLING
		
	return false
	
func apply_gravity(delta):
	if speed[1]<450:
		speed[1] += gravity*delta

func take_hit(damage_source):
	var specials = ["saw", "Fallzone", "spike_ball", "Railgun", "Spikes", "rock_head"]
	life-=1
	if specials.has(damage_source.name):
		life = 0
	current_state = HIT
	emit_signal("change_life", life, max_life)
	apply_knockback(damage_source)
	if life<=0:
		dies()
		return false
	return true
	
func _on_hurtbox_body_entered(body):
	if $immunity_frames.is_stopped():
		phy_state = PhyState.STOPPED
		
		if body.has_method("destroy"):
			body.destroy()
			
		if current_state!=DEAD:
			if !take_hit(body):
				return false
		
		$immunity_frames.start()
	
func apply_knockback(colisor):
	speed = Vector2.ZERO
	var direction = colisor.global_position.direction_to(self.global_position)
	knockback_dir = direction
	if current_state!=DEAD:
		speed = direction*550
		if colisor.has_method("get_velocity"):
			if colisor.get_velocity() is float or colisor.get_velocity() is int:
				if colisor.get_velocity()>550:
					if colisor.name.find("Rhino")!=-1:
						if colisor.current_state == colisor.ATTACK:
							direction.y = -0.1
					speed = direction*colisor.get_velocity()
				

func get_collisions():
	get_node("HitBox").set_deferred("disabled", false)
	for colliders in get_slide_count():	
		var collider_obj = get_slide_collision(colliders)
		#plataforma que cai
		
		if collider_obj.collider!=null:
			if collider_obj.collider.has_method("collide_with"):
				collider_obj.collider.collide_with(collider_obj, self)
		
			if collider_obj.collider.name=="hurtbox":
					if collider_obj.collider.get_parent().has_method("take_hit"):
						collider_obj.collider.get_parent().take_hit()
					elif collider_obj.collider.get_parent().has_method("destroy"):
						collider_obj.collider.get_parent().destroy()
					speed[1]=-345
					jumps = 1
		
			
func dies():
	visible = false
	current_state = DEAD
	has_gravity = false
	Transition.blink()
	var ragdoll = ragdoll_instance.instance()
	ragdoll.get_node("Sprite").texture = $AnimationPlayer.get_animation("Hit").track_get_key_value(1, 0)
	ragdoll.apply_impulse(knockback_dir, Vector2(knockback_dir.x*120,knockback_dir.y*200))
	ragdoll.gravity_scale = 3
	ragdoll.weight = 20
	ragdoll.angular_velocity = 20
	ragdoll.global_position = global_position
	ragdoll.get_node("VisibilityNotifier2D").connect("screen_exited", self, "on_ragdoll_screen_exited")
	ragdoll_spawned = ragdoll
	get_parent().call_deferred("add_child",ragdoll)
	emit_signal("change_life", 0, max_life)
	get_node("HitBox").set_deferred("disabled", true)
	get_node("hurtbox/shape").set_deferred("disabled", true)
	

func on_ragdoll_screen_exited():
	ragdoll_spawned.get_node("VisibilityNotifier2D").disconnect("screen_exited", self, "on_ragdoll_screen_exited")
	Global._reset_current()
		
func checkpoint_entered(new_pos):
	Global.last_checkpoint = new_pos
	
func make_dust():

	var dust = dust_instance.instance()
	dust.get_node("dust").emitting = true
	dust.position.x = position.x+$dust_origin.position.x*-dir
	dust.position.y = position.y+$dust_origin.position.y
	dust.scale.x = sign($Texture.scale.x)
	
	if in_wall():
		dust.rotation_degrees = 90
		dust.position.x = position.x+$dust_wall_origin.position.x*sign($Texture.scale.x)
		dust.position.y = position.y+$dust_wall_origin.position.y
	
	get_parent().add_child(dust)
	


func _on_dust_cooldown_timeout():
	if in_wall():
		if !$wall_time.is_stopped():
			if $wall_time.time_left<$wall_time.wait_time/2:
				let_dust = true
	else:
		let_dust = true


func _on_wall_time_timeout():
	can_grab = false


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Double_Jump":
			current_state = FALLING
		"Hit":
			current_state = IDLE
			if phy_state == PhyState.STOPPED:
				phy_state = PhyState.FREE

