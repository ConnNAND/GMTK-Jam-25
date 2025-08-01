extends SubViewportContainer

@export var Rocketeer:PackedScene

func ready_player(playerInfo, spawnLocation):
	if playerInfo[1]==0:
		var temp = Rocketeer.instantiate()
		$SubViewport.add_child(temp)
		temp.global_transform.origin = spawnLocation
		temp.player_id = playerInfo[0]
		$SubViewport/FollowCamera.target = temp
		temp.camera_orientation = $SubViewport/FollowCamera/Camera3D
		temp.timer = $SubViewport/GameTimer
		$SubViewport/GameTimer.resume_stopwatch_timer()
		$SubViewport/Speedometer.target = temp
