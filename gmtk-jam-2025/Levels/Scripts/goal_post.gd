extends Area3D

var list = []
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.respawn_point = global_transform
		var successful_lap = true
		for i in get_children():
			if i is Area3D:
				if i.entered_checkpoint.find(body.player_id)!=-1:
					i.entered_checkpoint.erase(body.player_id)
					continue
				else:
					successful_lap = false
					break
		if successful_lap:
			if body.windspeed < -5:
				$Horn.play()
			else:
				$Vibe.play()
			if body.timer:
				body.timer.cross_goal_post()
			for i in get_tree().get_nodes_in_group("stopwatch"):
				if i.player_id == body.player_id:
					i.reset()
					break
			for i in get_tree().get_nodes_in_group("speedbuff"):
				if i.player_id == body.player_id:
					i.reset()
					break
