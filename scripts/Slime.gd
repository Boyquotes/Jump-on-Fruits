extends Patrol_Enemy
var slime_particles = preload("res://Pixel Adventure 2/Enemies/Slime/Particles (62x16).png")
var remains = preload("res://projectiles/remains.tscn")

var step = 1
var this_life = 8
var TRANSFORMED = false

func _ready():
	lifes = this_life
	has_gravity = true

func dies():
	if step<3:
		if !TRANSFORMED:
			for i in range(4):
				var sprite = Sprite.new()
				sprite.texture = slime_particles
				sprite.hframes = 4
				sprite.frame = i
				var remain = remains.instance()
				remain.add_child(sprite)
				remain.apply_impulse(Vector2(rand_range(1,-1), 1), Vector2(rand_range(70,120),rand_range(-150,-250)))
				remain.position = Vector2(global_position.x+10*i, global_position.y)
				remain.angular_velocity = 45
				get_parent().call_deferred("add_child",remain)
		
			for i in range(4):
				var replic = self.duplicate()
				replic.this_life*=0.5
				replic.scale *= 0.75
				replic.position.x = global_position.x+rand_range(-30,30)
				replic.position.y = global_position.y
				replic.speed = rand_range(speed*2,speed*4)
				replic.step = step+1
				if i==0 or i==2:
					replic.current_side = Sides.LEFT
				else: 
					replic.current_side = Sides.RIGHT
				
				get_parent().call_deferred("add_child",replic)
				
				queue_free()
			TRANSFORMED = true
			
	else: 
		current_state = DEAD
		$hitbox.set_deferred("disabled", true)
		$hurtbox/area.set_deferred("disabled", true)
		$animation.play("dead")	
	

func get_velocity():
	return Vector2(movement.x*24, movement.y)
