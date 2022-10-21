extends StaticBody2D
export var power = 390
var current_rotation
func _ready():
	pass 
	
func _physics_process(_delta):
	pass

func collide_with(this, player):
	$animation.play("triggered")
	$hit_area.set_deferred("disabled", true)
	var force = Vector2.ZERO
	
	current_rotation = rotation_degrees
	
				
	#tratamento de força com base no ângulo
	
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
		#Se o ângulo não for paralelo aos 2 eixo
		pass
	
	#Adiciona força no jogador equivalente ao ângulo de direção
	player.speed = 0
	player.speed = power*force

func _on_animation_animation_finished(anim_name):
	if anim_name == "triggered":
		$animation.play("idle")
		$hit_area.set_deferred("disabled", false)
