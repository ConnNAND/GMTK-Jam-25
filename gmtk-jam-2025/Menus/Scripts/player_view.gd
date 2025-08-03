extends SubViewportContainer

@export var Rocketeer:PackedScene
var playerID = -1
var pause_held_flag = false
var player : CharacterBody3D
var finished = false
var pausable : bool = false
var player_collision_layer : int

func ready_player(playerInfo, spawnLocation):
	playerID = playerInfo[0]
	%PauseMenu.prepare_menu(playerID)
	%PauseMenu.quit.connect(game_over)
	if playerInfo[1]==0:
		player = Rocketeer.instantiate()
		$SubViewport.add_child(player)
		player.global_transform.origin = spawnLocation
		player.player_id = playerInfo[0]
		$SubViewport/FollowCamera.target = player
		player.camera_orientation = $SubViewport/FollowCamera/Camera3D
		player.timer = $SubViewport/GameTimer
		player.lap_counter = $SubViewport/LapCounter
		$SubViewport/Speedometer.target = player
		player_collision_layer = player.collision_layer
	if !get_parent().get_parent().first:
		get_parent().get_parent().first = player
		$SubViewport.audio_listener_enable_3d = true
		

func _process(_delta):
	if (playerID == 99 and (Input.is_key_pressed(KEY_ESCAPE)) or Input.is_joy_button_pressed(playerID,JOY_BUTTON_START)):
		if not pause_held_flag and pausable:
			pause_held_flag = true
			toggle_pause()
	else: pause_held_flag = false

func toggle_pause():
	player.is_paused = not player.is_paused
	if player.is_paused:
		player.collision_layer = 0
		%PauseMenu.visible = true
		player.process_mode = Node.PROCESS_MODE_DISABLED
		$SubViewport/GameTimer.pause_game_timer()
	else:
		player.collision_layer = player_collision_layer
		%PauseMenu.visible = false
		player.process_mode = Node.PROCESS_MODE_INHERIT
		$SubViewport/GameTimer.resume_game_timer()


func _on_game_timer_overtime_timer_timeout() -> void:
	game_over()

func game_over():
	%PauseMenu.visible = false
	finished = true
	visible = false
	get_parent().check_over()
	PlayerData.bestTime[playerID] = $SubViewport/GameTimer._pb_seconds
	PlayerData.lapCount[playerID] = $SubViewport/LapCounter.laps
