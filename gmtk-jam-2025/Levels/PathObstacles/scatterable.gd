extends PathFollow3D

@export_file var scatterable

var units = 30
@export var radius:float = 20
@export var amount_min = 1
@export var amount_max = 7

func _ready():
	for i in range(randi_range(amount_min, amount_max)):
		var temp:Node = load(scatterable).instantiate()
		add_child(temp)
		temp.transform.origin += Vector3(randf_range(-radius/2, radius/2), 0, randf_range(-radius/2, radius/2))
		if "origin_point" in temp:
			temp.origin_point = temp.global_transform.origin
