extends Node2D

export(String, FILE, "*.tscn") var target_path
onready var confetti = get_node("confetti")
onready var animation = get_node("animation")
var triggered = false


func _ready():
	confetti.emitting = false

func _on_Area2D_body_entered(body):
	#pass scene after transition
	if(body.name == "Player" and !triggered):
		print("entrou")
		animation.play("triggered")
		confetti.emitting = true
		triggered = true
		print(target_path)
		Transition.change_scene(target_path, true)
