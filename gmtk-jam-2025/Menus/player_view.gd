extends SubViewportContainer

@export var Rocketeer:PackedScene

func ready_player(screenSize, playerInfo, spawnLocation):
	if playerInfo[1]==0:
		var temp = Rocketeer.instantiate()
		$SubViewport.add_child(temp)
		temp.global_transform.origin = spawnLocation
		temp.player_id = playerInfo[0]
