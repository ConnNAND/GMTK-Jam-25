extends SpringArm3D

@export var target : Node3D
var follow_distance : float = 1.0
var placement_offset : Vector3 = Vector3()
var follow_speed : float = 10.0
func _ready():
	spring_length = 8.0

func _process(delta):
	var placement_offset : Vector3 = target.global_basis.z * follow_distance
	global_position = lerp(global_position, target.global_position + placement_offset, delta * follow_speed)
	look_at(target.position, target.global_basis.y)
