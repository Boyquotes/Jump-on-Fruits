extends "res://scripts/Interactive_Trap.gd"

export var auto = false

func _ready():
	pass

func _physics_process(delta):
	check_animations()

func check_animations():
	if on:
		toggle()
		$animacao.play("hit")

func _on_animation_finished(anim_name):
	if anim_name == "fire":
		$animacao.play("idle")
		$fire/fire_hitbox.set_deferred("disabled", true)
		get_node("active_area").hitted = false
		
	elif anim_name == "hit":
		$animacao.play("fire")
		$fire/fire_hitbox.set_deferred("disabled", false)
		
