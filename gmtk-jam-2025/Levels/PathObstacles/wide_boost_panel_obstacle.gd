extends PathFollow3D

var units = 50

func _ready() -> void:
	$BoostPanel/MeshInstance3D.mesh = $BoostPanel/MeshInstance3D.mesh.duplicate()
	$BoostPanel/CollisionShape3D.shape = $BoostPanel/CollisionShape3D.shape.duplicate()
	match randi_range(0, 7):
		0:
			$BoostPanel/CollisionShape3D.shape.size.x = 20
			$BoostPanel/MeshInstance3D.mesh.size.x = 20
		1:
			$BoostPanel/CollisionShape3D.shape.size.x = 7
			$BoostPanel/MeshInstance3D.mesh.size.x = 7
			h_offset = 6
		2:
			$BoostPanel/CollisionShape3D.shape.size.x = 7
			$BoostPanel/MeshInstance3D.mesh.size.x = 7
			h_offset = -6
		_:
			$BoostPanel/CollisionShape3D.shape.size.x = 3
			$BoostPanel/MeshInstance3D.mesh.size.x = 3
			h_offset = randf_range(-12, 12)
