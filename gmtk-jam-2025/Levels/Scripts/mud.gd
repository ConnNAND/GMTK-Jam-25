extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.hinderance += 0.5
		$AudioStreamPlayer.play()


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.hinderance -= 0.5
