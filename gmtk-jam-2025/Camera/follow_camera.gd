extends SpringArm3D

@export var target : Node3D
var extra_height : float = 2.0

func _ready():
	spring_length = 8.0

func _process(delta):
	global_position = lerp(global_position, target.global_position + Vector3(target.global_basis.z.x,1,target.global_basis.z.z), delta * 5)
	look_at(target.position)
