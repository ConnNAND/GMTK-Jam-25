extends PathFollow3D

var active = false

func _ready() -> void:
	progress_ratio = randf_range(0, 1)

func _process(delta: float) -> void:
	progress += delta*10
	if $GroundCheck.is_colliding():
		$GroundCheck/LightningBump.global_position = $GroundCheck.get_collision_point()


func _on_lightning_timer_timeout() -> void:
	$LightningTimer.wait_time = randf_range(5, 20)
	$GroundCheck.position.x = randf_range(-10, 10)
	$GroundCheck.position.y = randf_range(-10, 10)
	if active:
		$GroundCheck/LightningBump/OmniLight3D.visible = true
		await get_tree().create_timer(3).timeout
		$GroundCheck/LightningBump.monitoring = true
		$GroundCheck/LightningBump/Lightning.visible = true
		$GroundCheck/LightningBump/Thunder.play()
		await get_tree().create_timer(0.1).timeout
		$GroundCheck/LightningBump.monitoring = false
		$GroundCheck/LightningBump/OmniLight3D.visible = false
		$GroundCheck/LightningBump/Lightning.visible = false
	$LightningTimer.start()


func _on_active_timer_timeout() -> void:
	$ActiveTimer.wait_time = randf_range(30, 240)
	progress_ratio = randf_range(0, 1)
	active = true
	$Visual.visible = true
	$GroundCheck/LightningBump/Rain.play()
	await get_tree().create_timer(randf_range(240, 1000)).timeout
	active = false
	$GroundCheck/LightningBump/Rain.stop()
	$Visual.visible = false
	$ActiveTimer.start()


func _on_lightning_bump_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.default_speed = max(body.starting_speed, body.default_speed-5)
		body.top_speed = max(body.starting_top_speed, body.top_speed-6)
		body.actual_velocity = Vector3.ZERO
		body.target_velocity = Vector3.ZERO
		body.current_speed = 0
