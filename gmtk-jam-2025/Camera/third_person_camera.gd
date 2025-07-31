extends SpringArm3D

#Settings.
@export_group("Settings")
#Mouse settings.
@export_subgroup("Sensitivities")
#mouse sensitivity.
@export var mouse_sensitivity: float = 0.05
#controller sensitivity.
@export var controller_sensitivity: float = 0.5
#pitch clamp settings.
@export_subgroup("Clamp settings")
#max pitch in degrees.
@export var max_pitch : float = 80
#min pitch in degrees.
@export var min_pitch : float = -80
#Camera settings.
@export_subgroup("Camera settings")
#Camera distance.
@export var camera_distance : float = 8.0
@export_range(0.0,1.0) var controller_deadzone : float = 0.1

const sensitivity_scale : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring_length = camera_distance
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var controller = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var input : Vector2 = controller * controller_sensitivity * sensitivity_scale
	rotation.x -= input.y
	rotation.x = clamp(rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	rotation.y -= input.x

func _input(event):
	#Actual Camera controls
	if (event is InputEventMouseMotion):
		var input : Vector2 = event.relative * mouse_sensitivity * sensitivity_scale
		if (input != Vector2.ZERO):
			rotation.x -= input.y
			rotation.x = clamp(rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
			rotation.y -= input.x
