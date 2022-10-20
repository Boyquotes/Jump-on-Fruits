extends "res://scripts/Interactive_Trap.gd"

export var delay = 0.5
export var speed = 140

onready var animator = get_node("object/animation")
onready var movement = get_node("movement")

onready var object = get_node("object")

var velocity = Vector2.ZERO

var destiny

func _ready():
	destiny = Vector2(1,0)*$chain.rect_size.x+Vector2(8,0)
	if $chain.rect_size.y !=8:
		$chain.rect_size.y = 8
		$chain.rect_position.y = -4

	_start_tween(delay)
		
func _physics_process(delta):
	if on:
		if movement.is_active():
			object.position = object.position.linear_interpolate(velocity, 0.05)
		else:
			movement.resume_all()
			object.get_node("animation").play("on")
			object.get_node("hitbox").set_deferred("disabled", false)
	else:	
		movement.stop_all()	
		object.get_node("animation").play("RESET")
		object.get_node("hitbox").set_deferred("disabled", true)
		
func _start_tween(delay):
	movement.remove_all()
	movement.interpolate_property(self, "velocity", Vector2(-8,0), destiny, destiny.x/(speed*(destiny.x)/100), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	movement.start()
	yield(movement,"tween_completed")
	_back_tween(delay)

func _back_tween(delay):
	movement.remove_all()
	movement.interpolate_property(self, "velocity", destiny, Vector2(-8,0), destiny.x/(speed*(destiny.x)/100), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	movement.start()
	yield(movement,"tween_completed")
	_start_tween(delay)
	
func get_velocity():
	return velocity

