extends ColorRect

export var animation_progress = 0.0

func _process(_delta):
	material.set("shader_param/progress", animation_progress)


