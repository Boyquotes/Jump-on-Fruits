extends Object_Rail


func _ready():
	on = true
	object = get_node("saw")

func _physics_process(delta):
	if on:
		object.get_node("hitbox").set_deferred("disabled", false)
	else:
		object.get_node("hitbox").set_deferred("disabled", true)
