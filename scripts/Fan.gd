extends KinematicBody2D
export var power = 10
export var on = true

var bodies_in = []
var current_rotation
onready var area = $wind/area.position

func _ready():
	pass
	
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
			current_rotation = rotation_degrees
			#corrige a rotação se estiver negativa
			if current_rotation<0:
				current_rotation*=-1
				
			#tratamento de força com base no ângulo
			if int(round(current_rotation))%90==0 || current_rotation==0:
				var round_rotation = int(round(current_rotation))
				if round_rotation == 90:
					force = Vector2(1,0)
					
				elif round_rotation == 270:
					force = Vector2(-1,0)
					
				elif round_rotation == 0 || round_rotation == 360:
					force = Vector2(0,-1)
				
				else:
					force = Vector2(0,1)
					
			else: 		
				#Se o ângulo não for paralelo aos 2 eixos (Em trabalho)
				#force = Vector2(1,1).rotated(current_rotation)
				pass
						
				
			#Adiciona força no jogador equivalente ao ângulo de direção
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
