extends "res://scripts/Interactive_Trap.gd"
export var speed = 100

func _ready():
	pass
	
func _physics_process(delta):
	if on:
		rotation_degrees += speed*delta
		
	if rotation_degrees>360 || rotation_degrees<-360:
		rotation_degrees = 0
	
