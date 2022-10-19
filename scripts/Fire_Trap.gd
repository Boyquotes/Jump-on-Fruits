extends KinematicBody2D

export var on = false

func _ready():
	pass

func _physics_process(delta):
	check_animations()

func check_animations():
	if on:
		$animacao.play("fire")
		on = false

func _on_animation_finished(anim_name):
	if anim_name == "fire":
		$animacao.play("idle")
		get_node("active_area").hitted = false
		
	elif anim_name == "hit":
		$animacao.play("fire")
		
