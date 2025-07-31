extends SpringArm3D

@export var target : Node3D
var extra_height : float = 2.0
var follow_distance : float = 5.0
var follow_speed : float = 5.0
func _ready():
	spring_length = 8.0

func _process(delta):
	global_position = lerp(global_position, target.global_position + Vector3(target.global_basis.z.x * follow_distance,extra_height,target.global_basis.z.z * follow_distance), delta * follow_speed)
	look_at(target.position)
