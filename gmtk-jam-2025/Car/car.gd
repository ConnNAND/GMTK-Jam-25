extends PathFollow3D

func _process(delta):
	var new_progress = progress - 20 * delta
	if new_progress < 0:
		queue_free()
	else:
		progress = new_progress
