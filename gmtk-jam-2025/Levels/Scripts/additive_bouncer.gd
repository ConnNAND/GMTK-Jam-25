extends Area3D

@export var bounce_strength = 75


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.queue_bounce(self, false)
