extends SpringArm3D

@export var target : Node3D
var follow_distance : float = 1.0
var placement_offset : Vector3 = Vector3()
var follow_speed : float = 10.0

func _ready():
	spring_length = 8.0

func _process(delta):
	if target:
		var placement_offset : Vector3 = target.global_basis.z * follow_distance + Vector3.UP
		global_position = lerp(global_position, target.global_position + placement_offset, delta * follow_speed)
		$Node3D.look_at(target.position, target.global_basis.y)
		global_rotation.x = lerp_angle(global_rotation.x, $Node3D.global_rotation.x, 15*delta)
		global_rotation.y = lerp_angle(global_rotation.y, $Node3D.global_rotation.y, 15*delta)
		global_rotation.z = lerp_angle(global_rotation.z, $Node3D.global_rotation.z, 15*delta)
		#look_at(target.position, target.global_basis.y)
