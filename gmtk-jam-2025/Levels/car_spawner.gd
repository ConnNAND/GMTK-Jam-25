extends Path3D

@export var car:PackedScene


func _ready():
	var timer : SceneTreeTimer = get_tree().create_timer(10)
	timer.timeout.connect(make_car)

func make_car():
	print("made car")
	var new_car : PathFollow3D = car.instantiate()
	add_child(new_car)
	new_car.progress_ratio = 1.0
	var timer : SceneTreeTimer = get_tree().create_timer(randf_range(10,30))
	timer.timeout.connect(make_car)
