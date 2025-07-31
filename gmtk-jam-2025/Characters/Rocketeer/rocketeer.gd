extends CharacterBody3D
var gravity : float = 10
var jump_strength : float = 10
var jumps : int = 2
var move_speed : float = 10

func _physics_process(delta):
	if (is_on_floor()):
		velocity.y = 0
		jumps = 2
	else:
		velocity.y -= gravity * delta
	if (Input.is_action_just_pressed("jump") && jumps > 0):
			velocity.y += jump_strength
			jumps -= 1
	var movement := get_movement() * move_speed
	velocity.x = lerpf(velocity.x, movement.x,0.2)
	velocity.z = lerpf(velocity.z, movement.z,0.2)
	
	move_and_slide()

func get_movement() -> Vector3:
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_forward", "move_backward")
	var forward = %Camera.global_basis.z
	var right = %Camera.global_basis.x
	var move_direction : Vector3 = forward * input.y + right * input.x
	move_direction.y = 0
	return move_direction.normalized()
