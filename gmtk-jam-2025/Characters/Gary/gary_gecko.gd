extends BasicPlayer

var climbing = false


func _physics_process(delta: float) -> void:
	wind_calc(delta)
	get_target_speed() #checks the angle of the floor to see if you should speed up or slow down
	set_current_speed(delta)
	if actual_velocity.length() == 0:
		target_speed = default_speed
	movement = get_movement()
	target_velocity = movement * current_speed * boost_factor
	control_camera(delta)
	if (Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y) < -0.3  or (Input.is_key_pressed(KEY_W) and player_id==99)) and $climbray.is_colliding():
		climbing = true
	else:
		climbing = false
	control_jump(delta)
	if !climbing:
		actual_velocity.y -= gravity*delta
	else:
		actual_velocity.y = default_speed
	handle_momentum(delta)
	if camera_orientation: #makes motion direction relative to camera
		velocity = (global_transform.basis * actual_velocity.rotated(global_basis.y, camera_orientation.rotation.y))/hinderance
	move_and_slide()
	apply_floor_snap()
	orient_player_to_surface(delta)
