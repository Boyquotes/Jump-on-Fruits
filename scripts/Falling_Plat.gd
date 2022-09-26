extends KinematicBody2D


onready var initial_pos = global_position
onready var initial_rotation = global_rotation
onready var timer = $Timer
onready var animation = $AnimationPlayer
var respawn_time = 4
var gravity = 700
var velocity = Vector2(0,0)
var triggered = false
var rotation_speed = 1.3
var rotation_dir = 1

func _ready():
	set_physics_process(false)
	#print(initial_pos)
	timer.one_shot = true


func _physics_process(delta):
	if triggered:
		velocity[1] = -100
	triggered = false
	velocity[1] += gravity*delta
	velocity = move_and_slide(velocity)
	rotation += (rotation_speed*rotation_dir)*delta

func collide_with(_collisor: KinematicCollision2D, _body: KinematicBody2D):
	if !triggered:
		triggered = true
		timer.start(0.8)
		animation.play("triggered")

func _on_Timer_timeout():
	get_node("collider").set_deferred("disabled", true)
	animation.play("off")
	set_physics_process(true)
	respawn()

func respawn():
	yield(get_tree().create_timer(respawn_time), "timeout")
	set_physics_process(false)
	global_position = initial_pos
	global_rotation = initial_rotation
	triggered = false
	animation.play("respawn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="respawn":
		animation.play("on")
		get_node("collider").set_deferred("disabled", false)
		
