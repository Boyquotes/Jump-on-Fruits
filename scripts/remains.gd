extends RigidBody2D

func _ready():
	weight = 11.3
	pass

func _on_life_time_timeout():
	queue_free()
