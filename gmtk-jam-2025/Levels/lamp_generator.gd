extends Node3D

@export var num_lamps : int = 100
@export var lamp : PackedScene
@export var path : Path3D
var offset : float = -12.0

func _ready():
	var progress_amount : float = 0
	for i in range(num_lamps):
		progress_amount += 1.0 / num_lamps
		make_lamp(progress_amount)

func make_lamp(progress : float):
	print("lamp: made lamp")
	var new_lamp : PathFollow3D = lamp.instantiate()
	path.add_child(new_lamp)
	new_lamp.progress_ratio = progress
	new_lamp.h_offset = offset
	offset *= -1
	if (offset < 0):
		new_lamp.get_child(0).rotate_y(PI)
