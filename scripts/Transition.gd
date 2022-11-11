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
		Hud.reset_procedures(false)
		#pós loading
		fade_out(0)
		set_process(false)
		loader = null

func change_scene(path, new):
	
	var delay 
	
	if new:
		delay = 2
	else: 
		delay = 0
	
	fade_in(delay)
	yield(fx, "tween_completed")
	
	if path!="":
		loader = ResourceLoader.load_interactive(path)
		set_process(true)
		#assert(get_tree().change_scene(path) == OK)
	else:
		get_tree().reload_current_scene()
		Hud.reset_procedures(true)
		fade_out(0)
	
func fade_in(delay):
	fx.remove_all()
	fx.interpolate_property(get_node("overlay"), "animation_progress", 0, 1, duration_time/2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, delay)
	fx.start()

func fade_out(delay):
	fx.remove_all()
	fx.interpolate_property(get_node("overlay"), "animation_progress", 1, 0, duration_time/2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, delay)
	fx.start()

func make_transition(delay):
	fade_in(delay)
	yield(fx, "tween_completed")
	fade_out(delay)

func blink():
	fx.remove_all()
	fx.interpolate_property(get_node("fast_overlay"), "color", Color(0,0,0,0), Color(1,1,1,1), 0.15, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, 0)
	fx.start()
	yield(fx, "tween_completed")
	fx.remove_all()
	fx.interpolate_property(get_node("fast_overlay"), "color",  Color(1,1,1,1), Color(0,0,0,0), 0.4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, 0)
	fx.start()


