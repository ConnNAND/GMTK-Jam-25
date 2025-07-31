extends CharacterBody3D

var player_id:int = 0
var input_dir:Vector2 = Vector2.ZERO
var target_velocity:Vector3 = Vector3.ZERO
var actual_velocity:Vector3 = Vector3.ZERO
var speed:float
var acceleration:float
var turning:float
var max_speed:float


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()*delta
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.device == player_id:
		input_dir = Vector2.ZERO
		if event.is_action_pressed("move_forward"):
			input_dir.y += event.get_action_strength("move_forward")
		if event.is_action_pressed("move_backward"):
			input_dir.y -= event.get_action_strength("move_backward")
		if event.is_action_pressed("move_left"):
			input_dir.x -= event.get_action_strength("move_left")
		if event.is_action_pressed("move_right"):
			input_dir.x += event.get_action_strength("move_right")
		if event.is_action_pressed("jump"):
			jump()



func jump():
	if is_on_floor():
		velocity.y = 10
