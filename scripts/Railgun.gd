extends Togglable_Object

var destination_cord = Vector2.ZERO
var laser_width = 0
var in_range = false
var emitting = false

onready var collision_raycast = get_node("collision_detector")
onready var laser_end = get_node("laser_end")
onready var laser = get_node("laser")
onready var last_point = laser.get_point_count()-1



func _ready():
	laser.width = laser_width
	collision_raycast.cast_to.x = 0
	$laser.set_point_position(0, Vector2(0,6))
	

func _physics_process(delta):
	laser.width = laser_width
	check_collision()
	update_ray()
	if on:
		if !in_range and emitting:
			close_laser()
			
		elif in_range and !emitting:
			open_laser()
	
func check_collision():
	if collision_raycast.is_colliding():
		collision_raycast.force_raycast_update()
		laser_end.global_position = collision_raycast.get_collision_point()	
		in_range = true
	else:
		in_range = false

func update_ray():
	$damage_area.position.y = laser_end.position.y/2
	$damage_area/damage.shape.extents.y = laser_end.position.y/2
	$laser_light.scale.y = laser_end.position.y/200
	$laser_light.position.y = laser_end.position.y/2
	laser.set_point_position(last_point, laser_end.position)
	$particles/wall_particles.position = laser_end.position
	$particles/laser_particles.position.y = laser_end.position.y/2
	$particles/laser_particles.process_material.emission_box_extents.y = laser_end.position.y/2

func open_laser():
	emitting = true
	$Tween.remove_all()
	$Tween.interpolate_property(self, "laser_width", 0, 12, 0.2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.start()
	$laser_light.enabled = true
	$fade_light.enabled = true
	
	for particle in $particles.get_children():
		particle.emitting = true
		
	yield($Tween, "tween_completed")
	$damage_area/damage.set_deferred("disabled", false)
	$AnimationPlayer.play("active")
	
	
func close_laser():
	emitting = false
	$Tween.remove_all()
	$Tween.interpolate_property(self, "laser_width", 12, 0, 0.2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.start()
	
	for particle in $particles.get_children():
		particle.emitting = false
		
	yield($Tween, "tween_completed")
	$laser_light.enabled = false
	$fade_light.enabled = false
	$damage_area/damage.set_deferred("disabled", true)
	$AnimationPlayer.play("idle")
	
	$Tween.remove_all()


func toggle():
	on = !on
	
	if in_range:
		if on and !emitting:
			open_laser()
			
		elif !on and emitting:
			close_laser()


func _on_damage_area_body_entered(body):
	if in_range and on:
		if body.name == "Player":
			if body.has_method("_on_hurtbox_body_entered"):
				if !body.hitted:
					body._on_hurtbox_body_entered(self)
		else: 
			if body!=self:
				body.dies()
