extends KinematicBody2D

var direction = Vector2.ZERO
var speed = 340
var duration = 15
var movement = Vector2.ZERO
var piece_resource = preload("res://Pixel Adventure 2/Enemies/Plant/Bullet Pieces.png")
var remains = preload("res://projectiles/remains.tscn")


func _ready():
	$Timer.wait_time = duration
	$Timer.start()

func _physics_process(delta):
	movement = direction*speed*delta
	var collision = move_and_collide(movement)
	if collision:
		destroy()

func instance_remain(sprite_frame):
	var sprite = Sprite.new()
	sprite.texture = piece_resource
	sprite.hframes = 2
	sprite.frame = 0
	var new_remain = remains.instance()
	new_remain.global_position = global_position
	sprite.frame = sprite_frame
	new_remain.add_child(sprite)
	new_remain.weight = rand_range(17.2,28.9)
	new_remain.angular_velocity = 45
	new_remain.apply_impulse(Vector2(-movement.x, 1),Vector2((sqrt(speed))*-movement.x, rand_range(-120,80)))
	get_parent().call_deferred("add_child",new_remain)
	
func destroy():
	var index = 0
	while index<2:
		instance_remain(index)
		index+=1
	queue_free()


func _on_Timer_timeout():
	destroy()

func get_velocity():
	return movement
