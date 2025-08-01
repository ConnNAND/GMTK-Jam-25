extends CharacterBody3D

var player_id:int = 0
var movement_input:Vector4 = Vector4.ZERO
var target_velocity:Vector3 = Vector3.ZERO
var actual_velocity:Vector3 = Vector3.ZERO
var current_speed:float
var target_speed:float
var floor_incline:float

var acceleration:float = 0.9
var turning:float = 2
var default_speed:float = 10
var top_speed:float = 50
var jump_strength:float = 15
var jump_just_pressed = false
var unique_ability:float = 25

var hinderance:float = 1
var boost_factor:float = 2

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var up_vec = Vector3.UP

var timer

@export var camera_orientation:Node3D
var respawn_point : Transform3D = Transform3D.IDENTITY

var spare_jump = true

func _physics_process(delta: float) -> void:
	#checks the angle of the floor to see if you should speed up or slow down
	floor_incline = (global_transform.basis.z.normalized().y + 1)/2
	if floor_incline <= 0.5:#looking up
		target_speed = floor_incline*2 * default_speed
	elif floor_incline > 0.5:#looking down
		target_speed = floor_incline * top_speed
	
	if (target_speed < current_speed and is_on_floor()):
		current_speed = move_toward(current_speed, target_speed, delta*2*acceleration*boost_factor)
	elif target_speed > current_speed:
		current_speed = move_toward(current_speed, target_speed, delta*4*acceleration*boost_factor)
	
	if actual_velocity.length() == 0:
		target_speed = default_speed
		
	var movement : Vector3 = get_movement()
	target_velocity = movement * current_speed * boost_factor
	
	#rotating so the camera moves
	if abs(Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X)) > 0.3:
		rotate(global_transform.basis.y, -Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X)*delta*turning/hinderance)
	if abs(Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)) > 0.3:
		rotate(global_transform.basis.y, -Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)*delta*turning/hinderance)
	if Input.is_key_pressed(KEY_A) and player_id==99:
		rotate(global_transform.basis.y, delta*turning)
	if Input.is_key_pressed(KEY_D) and player_id==99:
		rotate(global_transform.basis.y, -delta*turning)
	if Input.is_key_pressed(KEY_Q) and player_id==99:
		rotate(global_transform.basis.y, delta*turning)
	if Input.is_key_pressed(KEY_E) and player_id==99:
		rotate(global_transform.basis.y, -delta*turning)
	
	if is_on_floor():
		gravity = 0
		floor_snap_length = 0.1
		spare_jump = true
	if Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) or (Input.is_key_pressed(KEY_SPACE) and player_id==99):
		if !jump_just_pressed:
			jump_just_pressed = true
			jump()
	else:
		jump_just_pressed = false
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
		velocity = (global_transform.basis * actual_velocity.rotated(global_basis.y, camera_orientation.rotation.y))/hinderance
	
	move_and_slide()
	apply_floor_snap()
	
	# Should be able to rotate x basis (pitch) based on player momentum
	# This should pull rotation away from vertical, 
	# and return it to vertical when momentum is lost
	# The movement relative to their "ground"
	if is_on_floor() and velocity.length()>2:
		up_vec.x = rotate_toward(up_vec.x, get_floor_normal().x, delta*5)
		up_vec.y = rotate_toward(up_vec.y,get_floor_normal().y, delta*5)
		up_vec.z = rotate_toward(up_vec.z,get_floor_normal().z, delta*5)
	else:
		up_vec.x = rotate_toward(up_vec.x,Vector3.UP.x, delta)
		up_vec.y = rotate_toward(up_vec.y,Vector3.UP.y, delta)
		up_vec.z = rotate_toward(up_vec.z,Vector3.UP.z, delta)
	up_vec = up_vec.normalized()
	global_basis.y = up_vec
	global_basis.x = global_basis.y.cross(global_basis.z)
	global_basis.z = global_basis.x.cross(global_basis.y)
	global_basis = global_basis.orthonormalized()
	up_direction = global_transform.basis.y
	

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
		actual_velocity.y = jump_strength / hinderance
		floor_snap_length = 0
	#ROCKETEER ONLY
	elif spare_jump:
		actual_velocity.y = unique_ability / hinderance
		floor_snap_length = 0
		spare_jump = false


func kill():
	global_transform = respawn_point
	velocity = Vector3.ZERO
	actual_velocity = Vector3.ZERO
