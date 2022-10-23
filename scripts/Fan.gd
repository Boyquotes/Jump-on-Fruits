extends Togglable_Object

export var power = 10
var bodies_in = []
var current_rotation
onready var area = $wind/area.position

func _ready():
	on = true
	$wind_end.position = Vector2(0,-$wind/area.shape.extents.y*2)
	
func _physics_process(delta):

	if on:
		#As particulas duram o equivalente ao tamanho da área
		$wind_particles.emitting = true
		$animation.play("on")
		var life_time = area.y*1.25/100
		$wind_particles.lifetime = life_time if life_time>0 else life_time*-1
		
		if(power<0):
			$wind_particles.position = $wind/area.position*2
			$wind_particles.rotation_degrees = 180
		
		#Para cada corpo dentro da área
		for body in bodies_in:
			var force = Vector2.ZERO
			force = global_position.direction_to($wind_end.global_position)
			body.speed += power*force
	else:
		$wind_particles.emitting = false
		$animation.play("RESET")

func _on_wind_body_entered(body):
	if body.name=="Player":
		bodies_in.append(body)

func _on_wind_body_exited(body):
	if(bodies_in.has(body)):
		bodies_in.remove(bodies_in.find(body))
