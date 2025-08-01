extends Area3D

var entered_checkpoint = []

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if entered_checkpoint.find(body.player_id)==-1:
			entered_checkpoint.append(body.player_id)
