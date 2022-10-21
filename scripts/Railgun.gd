extends "res://scripts/Interactive_Trap.gd"

var laser_speed = 300

var destination_cord = Vector2.ZERO
var laser_width = 0
var in_range = false
onready var laser = get_node("laser")
onready var destination_point = laser.get_point_count()-1



func _ready():
	$limit.cast_to.x = 0
	laser.width = laser_width
	if on:
		in_range = true
		open_laser()
	

func _physics_process(delta):
	laser.width = laser_width
	
	
	if $limit.is_colliding():
	
		$limit.force_raycast_update()
		destination_cord = $limit.get_collision_point()
		
		
		laser.set_point_position(0, Vector2(0,0))
		destination_cord.y = sign($limit.cast_to.y)*(destination_cord.y)
		laser.set_point_position(destination_point, Vector2(0,destination_cord.y*2))
			
		$particles/laser_particles.position.y = destination_cord.y/2
		$particles/laser_particles.process_material.emission_box_extents.y = destination_cord.y/2
			
		$particles/wall_particles.position.y = destination_cord.y*2
			
		$damage_area.position.y = destination_cord.y
		$damage_area/damage.shape.extents.y = destination_cord.y
		in_range = true
		print($limit.get_collision_point())
		
	else:
		in_range = false
		

func open_laser():
	$Tween.remove_all()
	$Tween.interpolate_property(self, "laser_width", 0, 12, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.start()
	if on and in_range:
		for particle in $particles.get_children():
			particle.emitting = true
	$damage_area/damage.set_deferred("disabled", false)
	yield($Tween, "tween_completed")
	$AnimationPlayer.play("active")
	on = true
	
		
	

func close_laser():
	$Tween.remove_all()
	$Tween.interpolate_property(self, "laser_width", 12, 0, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.start()
	
	for particle in $particles.get_children():
		particle.emitting = false
		
	$damage_area/damage.set_deferred("disabled", true)
	yield($Tween, "tween_completed")
	$AnimationPlayer.play("idle")
	
	on = false
	
		
	$Tween.remove_all()

func toggle():
	on = !on
	if on:
		open_laser()
	else:
		close_laser()


func _on_damage_area_body_entered(body):
	if in_range and on:
		if body.has_method("dies"):
			body.dies()
