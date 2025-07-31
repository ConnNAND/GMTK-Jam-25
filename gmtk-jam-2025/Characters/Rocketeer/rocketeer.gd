extends CharacterBody3D

var player_id:int = 0
var movement_input:Vector4 = Vector4.ZERO
var target_velocity:Vector3 = Vector3.ZERO
var actual_velocity:Vector3 = Vector3.ZERO
var default_speed:float = 10
var top_speed:float = 50
var current_speed:float
var target_speed:float
var floor_incline:float
var acceleration:float
var turning:float
var max_speed:float
var rotation_speed : float = 5
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var camera_orientation:Node3D

var spare_jump = true

func _physics_process(delta: float) -> void:
	#checks the angle of the floor to see if you should speed up or slow down
	floor_incline = (global_transform.basis.z.normalized().y + 1)/2
	if floor_incline <= 0.5:#looking up
		target_speed = floor_incline*2 * default_speed
	elif floor_incline > 0.5:#looking down
		target_speed = floor_incline * top_speed
	
	if (target_speed < current_speed and is_on_floor()):
		current_speed = move_toward(current_speed, target_speed, delta*2)
	elif target_speed > current_speed:
		current_speed = move_toward(current_speed, target_speed, delta*4)
		
	var movement : Vector3 = get_movement()
	target_velocity = movement * current_speed
	
	if Vector2(Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X), Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y)).length() > 0.3:
		var look_vec = Vector2(-Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X), -Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y))
		rotate_y(look_vec.x*delta*5)
	if Vector2(Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X), Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)).length() > 0.3:
		var look_vec = Vector2(-Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X), -Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y))
		rotate_y(look_vec.x*delta*5)
	
	if is_on_floor():
		gravity = 0
		floor_snap_length = 0.1
		spare_jump = true
	if Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) or (Input.is_key_pressed(KEY_SPACE) and player_id==99):
		jump()
	actual_velocity.y -= gravity*delta
	#variable jump height for holding the button down
	if (Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) or (Input.is_key_pressed(KEY_SPACE) and player_id==99)) and velocity.y > 0:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")/2
	else:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	#accelerate ad deccelerate at different speeds
	if movement.length() > 0.2:
		actual_velocity.x = lerp(actual_velocity.x, target_velocity.x, delta*2)
		actual_velocity.z = lerp(actual_velocity.z, target_velocity.z, delta*2)
	else:
		actual_velocity.x = lerp(actual_velocity.x, target_velocity.x, delta*5)
		actual_velocity.z = lerp(actual_velocity.z, target_velocity.z, delta*5)
	
	if camera_orientation:
		velocity = (global_transform.basis * actual_velocity.rotated(Vector3.UP, camera_orientation.rotation.y))
	
	move_and_slide()
	apply_floor_snap()
	
	# Takes care of the rotation of the player
	#var forward_dir = -global_basis.z
	#var move_dir = (movement - movement.project(global_basis.y)).normalized()
	#var full_rotation : float = forward_dir.signed_angle_to(move_dir, global_basis.y)
	#rotate(global_basis.y, lerpf(0, full_rotation, delta * rotation_speed))

func get_movement():
	var forward = movement_input.x - movement_input.w
	var right = movement_input.y - movement_input.z
	return Vector3(right, 0, forward).normalized()

func _input(event: InputEvent) -> void:
	if event.device == player_id and not event is InputEventKey:
		if event.is_action("move_forward"):
			movement_input.w = event.get_action_strength("move_forward")
		if event.is_action("move_backward"):
			movement_input.x = event.get_action_strength("move_backward")
		if event.is_action("move_right"):
			movement_input.y = event.get_action_strength("move_right")
		if event.is_action("move_left"):
			movement_input.z = event.get_action_strength("move_left")
	elif player_id == 99:#this means it's keyboard and mouse!
		if event.device == 0 and (not event is InputEventJoypadButton and not event is InputEventJoypadMotion):
			if event.is_action("move_forward"):
				movement_input.w = event.get_action_strength("move_forward")
			if event.is_action("move_backward"):
				movement_input.x = event.get_action_strength("move_backward")
			if event.is_action("move_right"):
				movement_input.y = event.get_action_strength("move_right")
			if event.is_action("move_left"):
				movement_input.z = event.get_action_strength("move_left")


func jump():
	if is_on_floor():
		actual_velocity.y = 10
		floor_snap_length = 0
	#ROCKETEER ONLY
	elif spare_jump:
		velocity.y = 10
		floor_snap_length = 0
		spare_jump = false
