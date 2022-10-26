extends Patrol_Enemy

enum spike_state{SPIKES_IN, SPIKES_OUT}
var current_spike_state = spike_state.SPIKES_IN
func _ready():
	attacking_unity = false
	has_gravity = true
	lifes = 4
	

func _physics_process(delta):
	match current_spike_state:
		spike_state.SPIKES_IN:
			set_collision_layer_bit(3, false)
			set_collision_mask_bit(5, false)
			set_collision_layer_bit(8, true)
			$hurtbox/area.set_deferred("disabled", false)
		spike_state.SPIKES_OUT:
			set_collision_layer_bit(3, true)
			set_collision_mask_bit(5, true)
			set_collision_layer_bit(8, false)
			$hurtbox/area.set_deferred("disabled", true)
			

func release_spikes():
	current_state = IDLE
	$animation.play("spikes_out")
	$spikes_cooldown.wait_time = rand_range(12,19)
	$spikes_cooldown.start()
	
func check_animations():
	if $animation.current_animation!="spikes_in" and $animation.current_animation!="spikes_out":
		var current = "idle" if current_spike_state == spike_state.SPIKES_IN else "idle_spiked"
		
		if current_state == PATROL:
			current = "moving" if current_spike_state == spike_state.SPIKES_IN else "moving_spiked"
		
		if current_state==HITTED:
			current = "hit"
		
		if current!=$animation.current_animation:
			$animation.play(current)
		
func _on_animation_animation_finished(anim_name):
	match anim_name:
		"hit":
			release_spikes()
		"idle":
			change_side()
			current_state = PATROL
		"idle_spiked":	
			change_side()
			current_state = PATROL
		"spikes_in":
			current_spike_state = spike_state.SPIKES_IN
			current_state = PATROL
		"spikes_out":
			current_spike_state = spike_state.SPIKES_OUT
			current_state = PATROL

func _on_spikes_cooldown_timeout():
	current_state = IDLE
	$animation.play("spikes_in")
