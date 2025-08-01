extends PathFollow3D

@export var collectsound:PackedScene

var player_id = 99

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.boost_factor += 0.4
		var temp = collectsound.instantiate()
		get_parent_node_3d().add_child(temp)
		temp.global_transform.origin = global_transform.origin
		reset()

func reset():
	progress_ratio = randf_range(0, 1)
	h_offset = randf_range(-10, 10)
