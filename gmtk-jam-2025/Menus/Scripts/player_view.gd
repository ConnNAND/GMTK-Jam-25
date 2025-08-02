extends SubViewportContainer

@export var Rocketeer:PackedScene
@export var PauseScreen:PackedScene
var playerID = -1
var pause_held_flag = false
var player : CharacterBody3D
var finished = false
var pause_screen : Control
var pausable : bool = false

func ready_player(playerInfo, spawnLocation):
	pause_screen = PauseScreen.instantiate()
	pause_screen.visible = false
	$SubViewport.add_child(pause_screen)
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
		playerID = playerInfo[0]
		

func _process(_delta):
	if (playerID == 99 and (Input.is_key_pressed(KEY_ESCAPE)) or Input.is_joy_button_pressed(playerID,JOY_BUTTON_BACK)):
		if not pause_held_flag and pausable:
			pause_held_flag = true
			toggle_pause()
	else: pause_held_flag = false

func toggle_pause():
	player.is_paused = not player.is_paused
	if player.is_paused:
		pause_screen.visible = true
		player.process_mode = Node.PROCESS_MODE_DISABLED
		$SubViewport/GameTimer.pause_game_timer()
	else:
		pause_screen.visible = false
		player.process_mode = Node.PROCESS_MODE_INHERIT
		$SubViewport/GameTimer.resume_game_timer()


func _on_game_timer_overtime_timer_timeout() -> void:
	pause_screen.visible = false
	finished = true
	visible = false
	get_parent().check_over()
	PlayerData.bestTime[playerID] = $SubViewport/GameTimer._pb_seconds
	PlayerData.lapCount[playerID] = $SubViewport/LapCounter.laps
