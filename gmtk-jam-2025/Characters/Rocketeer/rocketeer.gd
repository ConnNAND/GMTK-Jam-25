extends CharacterBody3D

var player_id : int = 0
var movement_input : Vector4 = Vector4.ZERO
var target_velocity : Vector3 = Vector3.ZERO
var actual_velocity : Vector3 = Vector3.ZERO
var speed : float = 25
var acceleration : float
var turning : float = 5
var max_speed : float
var jump_strength : float = 25
var gravity : float = 10
var jump_effect : Vector3 = Vector3.ZERO
var gravity_effect : Vector3 = Vector3.ZERO
const NATURAL_UP : Vector3 = Vector3.UP
var up_vec : Vector3 = Vector3.UP

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		gravity_effect += get_gravity() * delta * gravity
	else:
		gravity_effect = Vector3.ZERO
	gravity_effect += jump_effect
	jump_effect = Vector3.ZERO
	# Gets the movement as directed by the player
	var movement : Vector3 = get_player_movement()
	velocity = movement + gravity_effect
	move_and_slide()
	# Takes care of the rotation of the player
	var forward_dir = -global_basis.z
	# This line shouldnt be needed since the y component isnt introduced
	var move_dir = (movement - movement.project(global_basis.y)).normalized()
	#var move_dir = movement.normalized()
	if (move_dir != Vector3.ZERO):
		var full_rotation : float = forward_dir.signed_angle_to(move_dir, global_basis.y)
		global_basis = global_basis.rotated(global_basis.y,lerpf(0, full_rotation, delta * turning))
		global_basis = global_basis.orthonormalized()

	
	# Should be able to rotate x basis (pitch) based on player momentum
	# This should pull rotation away from vertical, 
	# and return it to vertical when momentum is lost
	# The movement relative to their "ground"
	if is_on_floor() and velocity.length()>2:
		up_vec.x = rotate_toward(up_vec.x, get_floor_normal().x, delta)
		up_vec.y = rotate_toward(up_vec.y,get_floor_normal().y, delta)
		up_vec.z = rotate_toward(up_vec.z,get_floor_normal().z, delta)
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
	

func get_player_movement():
	var forward = movement_input.x - movement_input.w
	var right = movement_input.y - movement_input.z
	return (global_basis.z * forward + global_basis.x * right).normalized() * speed

func _input(event: InputEvent) -> void:
	if event.device == player_id:
		if event.is_action("move_forward"):
			movement_input.w = event.get_action_strength("move_forward")
		if event.is_action("move_backward"):
			movement_input.x = event.get_action_strength("move_backward")
		if event.is_action("move_right"):
			movement_input.y = event.get_action_strength("move_right")
		if event.is_action("move_left"):
			movement_input.z = event.get_action_strength("move_left")
		if event.is_action("jump"):
			jump()



func jump():
	if is_on_floor():
		jump_effect = global_basis.y * jump_strength
