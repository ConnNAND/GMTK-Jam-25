extends MeshInstance3D

var shrinking = false
@export var shrink_speed = 0.7


func _physics_process(delta: float) -> void:
	if shrinking and scale.x>0.2:
		scale.x -= delta*shrink_speed
		scale.y -= delta*shrink_speed
		scale.z -= delta*shrink_speed
	elif scale.x <= 0.2 and visible:
		visible = false
		$StaticBody3D/CollisionShape3D.disabled = true
		refresh()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		shrinking = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		shrinking = false


func refresh():
	await get_tree().create_timer(10).timeout
	scale = Vector3(1, 1, 1)
	$StaticBody3D/CollisionShape3D.disabled = false
	visible = true
