extends "res://scripts/object_in_rail.gd"

func _ready():
	on = true
	speed = 75
	object = get_node("platform")
	pass

func _physics_process(delta):
	object.rotation_degrees = -rotation_degrees
