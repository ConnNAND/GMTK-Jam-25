extends BasicPlayer

var spare_jump = true


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_on_floor():
		spare_jump = true


func jump():
	jumping = true
	if is_on_floor():
		actual_velocity.y = jump_strength / hinderance
		floor_snap_length = 0
		$Jump.play()
	#ROCKETEER ONLY
	elif spare_jump:
		actual_velocity.y = unique_ability / hinderance
		floor_snap_length = 0
		spare_jump = false
		$Jetpack.play()
		$particles.emitting = true
