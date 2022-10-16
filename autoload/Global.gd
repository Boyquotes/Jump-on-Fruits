extends Node
var fruits = 0
var player_camera = null
var level_name = ""
var last_checkpoint = null
var checkpoint_on = []
onready var root = get_tree().get_root()

func _ready():
	_update_nodes()

func _update_nodes():
		var this_scene = root.get_child(root.get_child_count()-1)
		level_name = this_scene.name
		player_camera = this_scene.get_node("Player/MainCamera")

func _reset_current():
	Transition.change_scene("", false)
	Hud.reset_texture()
	Hud.reset_timer()
	fruits = 0
	_update_nodes()
