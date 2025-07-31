extends CharacterBody3D

var player_id:int = 0
var movement_input:Vector4 = Vector4.ZERO
var target_velocity:Vector3 = Vector3.ZERO
var actual_velocity:Vector3 = Vector3.ZERO
var speed:float
var acceleration:float
var turning:float
var max_speed:float
var rotation_speed : float = 5

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()*delta
	var movement : Vector3 = get_movement()
	velocity.x = movement.x * 5
	velocity.z = movement.z * 5
	move_and_slide()
	# Takes care of the rotation of the player
	var forward_dir = -global_basis.z
	var move_dir = (movement - movement.project(global_basis.y)).normalized()
	var full_rotation : float = forward_dir.signed_angle_to(move_dir, global_basis.y)
	rotate(global_basis.y, lerpf(0, full_rotation, delta * rotation_speed))

func get_movement():
	var forward = movement_input.x - movement_input.w
	var right = movement_input.y - movement_input.z
	return (global_basis.z * forward + global_basis.x * right).normalized()

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
		velocity.y = 10
