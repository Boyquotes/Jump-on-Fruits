extends KinematicBody2D
var hitted = false

func _ready():
	pass

func collide_with(body, player):
	if !hitted and !get_parent().auto:
		get_parent().toggle()
		hitted = true

