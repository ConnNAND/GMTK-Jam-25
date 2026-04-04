extends BasicPlayer

var gliding = false


func control_jump(delta):
	if is_on_floor():
		jumping = false
		if gliding:
			gliding = false
			$Body.visible = true
			$Flight.visible = false
		if (in_air):
			actual_velocity.y = -ProjectSettings.get_setting("physics/3d/default_gravity")
			in_air = false
		if velocity.length() > 0.5 and stepspeed < 0:
			$Step.pitch_scale = randf_range(0.9, 1.2)
			$Step.play()
			stepspeed = 5
		gravity = 0
		floor_snap_length = 0.1
	else:
		if not in_air and !jumping:
			actual_velocity.y = 0
			in_air = true
		if gliding:
			actual_velocity.y = -5
	if Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) or (Input.is_key_pressed(KEY_SPACE) and player_id==99) or (Input.is_action_pressed("jump") and player_id==99 and (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"))):
		if !jump_just_pressed:
			jump_just_pressed = true
			jump()
	else:
		jump_just_pressed = false
	if !gliding:
		actual_velocity.y -= gravity*delta
	#variable jump height for holding the button down
	if (Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) or (Input.is_key_pressed(KEY_SPACE) and player_id==99)) or (Input.is_action_pressed("jump") and player_id==99 and (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"))) and velocity.y > 0:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")/2
	else:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func jump():
	jumping = true
	if is_on_floor():
		actual_velocity.y = jump_strength / hinderance
		floor_snap_length = 0
		$Jump.play()
	else:
		gliding = !gliding
		$Fly.play()
		if gliding:
			$Flight.visible = true
			$Body.visible = false
		else:
			$Flight.visible = false
			$Body.visible = true
