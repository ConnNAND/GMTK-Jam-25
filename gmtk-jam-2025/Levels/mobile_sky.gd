extends MeshInstance3D

func _ready() -> void:
	if (OS.has_feature("mobile")):
		visible = true
