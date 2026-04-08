extends PathFollow3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Sprite3D/SpotLight3D.visible = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Sprite3D/SpotLight3D.visible = false
