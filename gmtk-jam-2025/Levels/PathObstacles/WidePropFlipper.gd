extends PathFollow3D

@export var units = 10

func _ready():
	if randi_range(0, 1)==1:
		get_child(0).rotation.y += 180
