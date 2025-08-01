extends Area3D

var list = []
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
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
			#do lap timer thing
			if body.timer:
				body.timer.cross_goal_post()
