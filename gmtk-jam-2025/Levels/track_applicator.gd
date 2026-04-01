extends Node3D

@export var track:Path3D
@export_file var obstacles:Array[String]


func apply_track_obstacles():
	var current_progress = 50
	while current_progress < track.curve.get_baked_length():
		var temp:PackedScene = load(obstacles[randi_range(0, obstacles.size()-1)])
		var obstacle:PathFollow3D = temp.instantiate()
		track.add_child(obstacle)
		obstacle.progress = current_progress
		if obstacle.get("units"):
			current_progress += obstacle.units
		else:
			current_progress += 50
	apply_checkpoints()

func apply_checkpoints():
	var placer = $Placer
	placer.reparent(track)
	placer.progress_ratio = 0
	var goalpost = $GoalPost
	goalpost.reparent(placer)
	goalpost.transform.origin = Vector3.ZERO
	goalpost.reparent(self)
	var checkpoints = []
	for i in goalpost.get_children():
		if i is Area3D:
			checkpoints.append(i)
	var progress:float = 1
	for i in checkpoints:
		placer.progress_ratio = progress / (checkpoints.size()+1)
		i.reparent(placer)
		i.transform.origin = Vector3.ZERO
		i.reparent(goalpost)
		progress += 1
	
