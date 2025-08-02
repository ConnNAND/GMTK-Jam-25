extends RigidBody3D

var origin_point = Vector3.ZERO

func _ready() -> void:
	origin_point = global_transform.origin
