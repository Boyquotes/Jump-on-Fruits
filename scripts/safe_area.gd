extends Area2D


func _ready():
	pass


func _on_safe_area_body_entered(body):
	if body.name=="Player":
		body.last_ground = position
