class_name Checkpoint extends Area3D

static var checkpoint_count = 3
@export var checkpoint_id : int = 0

func _on_body_entered(body: Node3D) -> void:
	if body is BasicPlayer and checkpoint_valid(body):
		
		set_checkpoint(body)
		play_sound(body)
	else:
		print("Entered wrong checkpoint OR not player")

func set_checkpoint(player : BasicPlayer) -> void:
	player.respawn_point = global_transform
	player.last_checkpoint = checkpoint_id

func play_sound(player : BasicPlayer) -> void:
	if player.windspeed < -5: $Collect.play()
	else: $VibeCollect.play()

func checkpoint_valid(player : BasicPlayer) -> bool:
	print((player.last_checkpoint + 1) % checkpoint_count)
	return (player.last_checkpoint + 1) % checkpoint_count == checkpoint_id
