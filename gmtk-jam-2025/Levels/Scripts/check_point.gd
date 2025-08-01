extends Area3D

var entered_checkpoint = []

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.respawn_point = global_transform
		if entered_checkpoint.find(body.player_id)==-1:
			entered_checkpoint.append(body.player_id)
			if body.windspeed < -5:
				$Collect.play()
			else:
				$VibeCollect.play()
