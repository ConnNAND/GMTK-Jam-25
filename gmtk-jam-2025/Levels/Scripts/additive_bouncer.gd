extends Area3D

@export var bounce_strength = 25

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.actual_velocity += global_transform.basis.y*bounce_strength
