extends PathFollow3D

func _process(delta):
	progress -= 20 * delta
