class_name Checkpoint extends Area3D

static var checkpoint_count = 5
@export var checkpoint_id : int = 0

func _on_body_entered(body: Node3D) -> void:
	if body is BasicPlayer and checkpoint_valid(body):
		set_respawn(body)
		play_sound(body)

func set_respawn(player : BasicPlayer) -> void:
	player.respawn_point = global_transform

func play_sound(player : BasicPlayer) -> void:
	if player.windspeed < -5: $Collect.play()
	else: $VibeCollect.play()

func checkpoint_valid(player : BasicPlayer) -> bool:
	return player.last_checkpoint == (checkpoint_id - 1) % checkpoint_count
