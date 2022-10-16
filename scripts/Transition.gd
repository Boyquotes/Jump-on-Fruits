extends CanvasLayer


onready var fx = get_node("animation_fx")
onready var root = get_tree().get_root()
export var duration_time = 4
var loader = null

func _ready():
	set_process(false)

func _process(_delta):
	var current_scene = root.get_child(root.get_child_count()-1)
	var err = loader.poll()
		
	if err == ERR_FILE_EOF:
		current_scene.queue_free()
		Global.last_checkpoint = null
		Global.checkpoint_on = []
		var resource = loader.get_resource()
		current_scene = resource.instance()
		root.add_child(current_scene)
		
		#Atualiza a cena atual
		get_tree().set_current_scene(current_scene)
		
		#pós loading
		fade_out()
		set_process(false)
		loader = null

func change_scene(path, new):
	fx.remove_all()
	
	var delay 
	
	if new:
		delay = 2
	else: 
		delay = 0
		
	fx.interpolate_property(get_node("overlay"), "animation_progress", 0, 1, duration_time/2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, delay)
	fx.start()
	yield(fx, "tween_completed")
	
	if path!="":
		loader = ResourceLoader.load_interactive(path)
		set_process(true)
		#assert(get_tree().change_scene(path) == OK)
	else:
		get_tree().reload_current_scene()
		fade_out()
		

func fade_out():
	fx.remove_all()
	fx.interpolate_property(get_node("overlay"), "animation_progress", 1, 0, duration_time/2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0)
	fx.start()
	Hud.reset_procedures()


