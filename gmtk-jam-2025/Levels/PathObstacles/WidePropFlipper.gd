extends PathFollow3D

@export var units = 0


func _ready():
	if randi_range(0, 1)==1:
		get_child(0).transform.scale *= -1
		h_offset *= -1
