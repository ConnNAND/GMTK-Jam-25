extends Node3D

@export var num_lamps : int = 100
@export var make_these : Array[PackedScene]
@export var path : Path3D
@export var offset : float = -12.0
var placer:PathFollow3D

func _ready():
	if get_child_count() > 0:
		placer = get_child(0)
		placer.reparent(path)
	var progress_amount : float = 0
	for i in range(num_lamps):
		progress_amount += 1.0 / num_lamps
		make_lamp(progress_amount)

func make_lamp(progress : float):
	var temp = make_these[randi_range(0, make_these.size()-1)].instantiate()
	if temp is PathFollow3D:
		var new_lamp : PathFollow3D = temp
		path.add_child(new_lamp)
		new_lamp.progress_ratio = progress
		new_lamp.h_offset = offset
		offset *= -1
		if (offset < 0):
			new_lamp.get_child(0).rotate_y(PI)
	else:
		placer.progress_ratio = progress
		placer.add_child(temp)
		temp.position = Vector3.ZERO
		temp.rotation = Vector3.ZERO
		placer.h_offset = offset
		offset *= -1
		temp.reparent(path)
		temp.rotation.x = 0
		temp.rotation.z = 0
