class_name Goalpost extends Checkpoint

func _on_body_entered(body: Node3D) -> void:
	if body is BasicPlayer and checkpoint_valid(body):
		set_checkpoint(body)
		increase_speed(body)
		play_sound(body)
		reset_timer(body)
		reset_items(body)
	else:
		print("Entered wrong checkpoint OR not player")

func play_sound(player : BasicPlayer) -> void:
	if player.windspeed < -5: $Horn.play()
	else: $Vibe.play()

func reset_timer(player : BasicPlayer):
	if player.timer:
		player.timer.cross_goal_post()
		player.lap_counter.increment()

func reset_items(player : BasicPlayer):
	for i in get_tree().get_nodes_in_group("stopwatch"):
		if i.player_id == player.player_id:
			i.reset()
			break
	for i in get_tree().get_nodes_in_group("speedbuff"):
		if i.player_id == player.player_id:
			i.reset()
			break

func increase_speed(player : BasicPlayer):
	player.starting_speed = player.default_speed + 1.25
	player.starting_top_speed = player.top_speed + 1.5
	player.default_speed += 2.5
	player.top_speed += 3
