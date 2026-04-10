extends CharacterBody3D
class_name BasicPlayer

var player_id:int = 0
var movement_input:Vector4 = Vector4.ZERO
var target_velocity:Vector3 = Vector3.ZERO
var actual_velocity:Vector3 = Vector3.ZERO
var current_speed:float
var target_speed:float
var floor_incline:float

var movement:Vector3 = Vector3.ZERO
var acceleration:float = 0.9
var initial_turning:float = 2
var turning:float = initial_turning
var starting_speed:float = 15
var default_speed:float = starting_speed
var starting_top_speed = 56
var top_speed:float = starting_top_speed
var jump_strength:float = 15
var jump_just_pressed = false
var unique_ability:float = 25

var hinderance:float = 1
var boost_factor:float = 1

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var up_vec = Vector3.UP
var bounce:Vector3 = Vector3.ZERO

var touch_turn = 0
var just_touched = false
var init_touch_coords:Vector2i
var current_touch_coords:Vector2i
var touch_walk_dir = 0

var timer
var lap_counter

var stepspeed = 5
var windspeed = -20
@onready var wind = $Wind

@export var camera_orientation:Node3D
var respawn_point : Transform3D = Transform3D.IDENTITY

var in_air : bool = true
var jumping:bool = false
var is_paused : bool = false


func _physics_process(delta: float) -> void:
	handle_basics(delta)


func get_movement():
	var forward = movement_input.x - movement_input.w
	var right = movement_input.y - movement_input.z
	if (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")) and player_id == 99:
		return Vector3(0, 0, touch_walk_dir)
	return Vector3(right/(pow(turning, 2)), 0, forward).normalized()


func _input(event: InputEvent) -> void:
	if event.device == player_id and not event is InputEventKey and not (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")):
		if event.is_action("move_forward"):
			movement_input.w = event.get_action_strength("move_forward")
		if event.is_action("move_backward"):
			movement_input.x = event.get_action_strength("move_backward")
		if event.is_action("move_right"):
			movement_input.y = event.get_action_strength("move_right")
		if event.is_action("move_left"):
			movement_input.z = event.get_action_strength("move_left")
	elif player_id == 99:#this means it's keyboard and mouse or touch controls!
		if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
			if event.is_action("move_forward"):
				touch_walk_dir = -1
			if event.is_action("move_backward"):
				touch_walk_dir = 1
			if event.is_action("break"):
				touch_walk_dir = 0
			if event is InputEventScreenTouch:
				if event.pressed:
					if not just_touched:
						init_touch_coords = event.position
						just_touched = true
						current_touch_coords = event.position
						touch_turn = 0
					else:
						Input.action_release("jump")
						current_touch_coords = event.position
						touch_turn = current_touch_coords.x - init_touch_coords.x
				else:
					if event.position.y <= init_touch_coords.y-25:
						simulate_jump(abs(event.position.y - (init_touch_coords.y)))
					elif event.position.y >= init_touch_coords.y+45:
						simulate_quick_break(abs(event.position.y - (init_touch_coords.y)))
					just_touched = false
					touch_turn = 0
			elif event is InputEventScreenDrag:
				current_touch_coords = event.position
				touch_turn = current_touch_coords.x - init_touch_coords.x
				#touch_turn = event.screen_velocity.x
		elif event.device == 0 and (not event is InputEventJoypadButton and not event is InputEventJoypadMotion) and not (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")):
			if event.is_action("move_forward"):
				movement_input.w = event.get_action_strength("move_forward")
			if event.is_action("move_backward"):
				movement_input.x = event.get_action_strength("move_backward")
			if event.is_action("move_right"):
				movement_input.y = event.get_action_strength("move_right")
			if event.is_action("move_left"):
				movement_input.z = event.get_action_strength("move_left")


func jump():
	jumping = true
	if is_on_floor():
		actual_velocity.y = jump_strength / hinderance
		floor_snap_length = 0
		$Jump.play()


func queue_bounce(bouncer):
	in_air = true
	bounce = bouncer.global_transform.basis.y*bouncer.bounce_strength


func kill():
	global_transform = respawn_point
	velocity = Vector3.ZERO
	actual_velocity = Vector3.ZERO
	default_speed = max(default_speed-5, starting_speed)
	top_speed = max(top_speed-6, starting_top_speed)
	$Death.play()


func wind_calc(delta):
	windspeed = min(Vector3(velocity.x, velocity.y/2, velocity.z).length()/3-20, 10)
	wind.volume_db = windspeed
	if stepspeed>0:
		stepspeed -= delta*velocity.length()


func get_target_speed():
	floor_incline = (global_transform.basis.z.normalized().y + 1)/2
	if floor_incline <= 0.5:#looking up
		target_speed = floor_incline*2 * default_speed
	elif floor_incline > 0.5:#looking down
		target_speed = floor_incline * top_speed


func set_current_speed(delta):
	if (target_speed < current_speed and is_on_floor()):
		current_speed = move_toward(current_speed, target_speed, delta*2*acceleration*boost_factor)
	elif target_speed > current_speed:
		current_speed = move_toward(current_speed, target_speed, delta*4*acceleration*boost_factor)


func control_camera(delta):
	#rotating so the camera moves
	turning = max(initial_turning, pow(current_speed, 1/5)+(current_speed/50))
	if abs(Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X)) > 0.3:
		rotate(global_transform.basis.y, -Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X)*delta*turning/hinderance)
	if abs(Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)) > 0.3:
		rotate(global_transform.basis.y, -Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)*delta*turning/hinderance)
	if Input.is_key_pressed(KEY_A) and player_id==99:
		rotate(global_transform.basis.y, delta*turning)
	if Input.is_key_pressed(KEY_D) and player_id==99:
		rotate(global_transform.basis.y, -delta*turning)
	if Input.is_key_pressed(KEY_Q) and player_id==99:
		rotate(global_transform.basis.y, delta*initial_turning)
	if Input.is_key_pressed(KEY_E) and player_id==99:
		rotate(global_transform.basis.y, -delta*initial_turning)
	if Input.is_joy_button_pressed(player_id, JOY_BUTTON_LEFT_SHOULDER):
		rotate(global_transform.basis.y, delta*initial_turning)
	if Input.is_joy_button_pressed(player_id, JOY_BUTTON_RIGHT_SHOULDER):
		rotate(global_transform.basis.y, -delta*initial_turning)
	if player_id==99 and (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")):
		rotate(global_transform.basis.y, -delta*touch_turn/78)
		#touch_turn = 0


func control_jump(delta):
	if is_on_floor():
		jumping = false
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
	if Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) or (Input.is_key_pressed(KEY_SPACE) and player_id==99) or (Input.is_action_pressed("jump") and player_id==99 and (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"))):
		if !jump_just_pressed:
			jump_just_pressed = true
			jump()
	else:
		jump_just_pressed = false
	actual_velocity.y -= gravity*delta
	#variable jump height for holding the button down
	if (Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) or (Input.is_key_pressed(KEY_SPACE) and player_id==99)) or (Input.is_action_pressed("jump") and player_id==99 and (OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"))) and velocity.y > 0:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")/2
	else:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func handle_momentum(delta):
	#accelerate and deccelerate at different speeds
	if movement.length() > 0.2:
		if (movement.z > 0 and actual_velocity.z >= 0) or (movement.z < 0 and actual_velocity.z <= 0):
			actual_velocity.z = lerp(actual_velocity.z, target_velocity.z, delta*2 / (top_speed/10))
		elif (movement.z >= 0 and actual_velocity.z < 0) or (movement.z <= 0 and actual_velocity.z > 0):
			actual_velocity.z = lerp(actual_velocity.z, target_velocity.z, delta*2)
		if (movement.x > 0 and actual_velocity.x >= 0) or (movement.x < 0 and actual_velocity.x <= 0):
			actual_velocity.x = lerp(actual_velocity.x, target_velocity.x, delta*2 / (top_speed/10))
		elif (movement.x >= 0 and actual_velocity.x < 0) or (movement.x <= 0 and actual_velocity.x > 0):
			actual_velocity.x = lerp(actual_velocity.x, target_velocity.x, delta*2)
	else:
		actual_velocity.x = lerp(actual_velocity.x, target_velocity.x, delta*5)
		actual_velocity.z = lerp(actual_velocity.z, target_velocity.z, delta*5)


func orient_player_to_surface(delta):
	# Should be able to rotate x basis (pitch) based on player momentum
	# This should pull rotation away from vertical, 
	# and return it to vertical when momentum is lost
	# The movement relative to their "ground"
	if is_on_floor() and velocity.length()>2:
		up_vec.x = rotate_toward(up_vec.x, get_floor_normal().x, delta*5)
		up_vec.y = rotate_toward(up_vec.y,get_floor_normal().y, delta*5)
		up_vec.z = rotate_toward(up_vec.z,get_floor_normal().z, delta*5)
	else:
		floor_snap_length = 0
		up_vec.x = rotate_toward(up_vec.x,Vector3.UP.x, delta)
		up_vec.y = rotate_toward(up_vec.y,Vector3.UP.y, delta)
		up_vec.z = rotate_toward(up_vec.z,Vector3.UP.z, delta)
	global_basis.y = up_vec
	global_basis.x = global_basis.y.cross(global_basis.z)
	global_basis.z = global_basis.x.cross(global_basis.y)
	global_basis = global_basis.orthonormalized()
	up_direction = global_transform.basis.y


func handle_basics(delta):
	wind_calc(delta)
	get_target_speed() #checks the angle of the floor to see if you should speed up or slow down
	set_current_speed(delta)
	if actual_velocity.length() == 0:
		target_speed = default_speed
	movement = get_movement()
	target_velocity = movement * current_speed * boost_factor
	control_camera(delta)
	control_jump(delta)
	handle_momentum(delta)
	if camera_orientation: #makes motion direction relative to camera
		velocity = (global_transform.basis * actual_velocity.rotated(global_basis.y, camera_orientation.rotation.y))/hinderance
	if bounce != Vector3.ZERO:
		in_air = true
		floor_snap_length = 0
		velocity += bounce
		bounce = Vector3.ZERO
	move_and_slide()
	apply_floor_snap()
	orient_player_to_surface(delta)


func simulate_jump(swipe_size):
	Input.action_press("jump")
	await get_tree().create_timer(0.0024 * swipe_size).timeout
	Input.action_release("jump")


func simulate_quick_break(swipe_size):
	touch_walk_dir = -0.1
	await get_tree().create_timer(0.005 * swipe_size).timeout
	touch_walk_dir = -1


func _on_bonk_check_body_entered(body: Node3D) -> void:
	$Ouch.play()
	actual_velocity *= 0.05
	target_velocity *= 0.05
