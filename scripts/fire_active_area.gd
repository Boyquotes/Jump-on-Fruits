extends KinematicBody2D
var hitted = false

func _ready():
	pass

func collide_with(body, player):
	if !hitted:
		get_parent().get_node("animacao").play("hit")
		hitted = true

