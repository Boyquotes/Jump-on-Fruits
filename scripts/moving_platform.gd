extends Object_Rail

func _ready():
	on = true
	speed = 75
	object = get_node("platform")
	pass

func _physics_process(delta):
	object.rotation_degrees = -rotation_degrees
