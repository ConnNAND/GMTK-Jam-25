extends Control

enum DATA_TYPE{BEST_TIME,LAP_COUNT}

func _ready():
	for t in PlayerData.bestTime:
		create_label(t, DATA_TYPE.BEST_TIME)
	
	for l in PlayerData.lapCount:
		create_label(l,DATA_TYPE.LAP_COUNT)

func create_label(playerID : int, data_type : DATA_TYPE):
	var label := Label.new()
	if data_type == DATA_TYPE.BEST_TIME:
		var time = PlayerData.bestTime[playerID]
		var minutes : float = floorf(time / 60.0)
		var seconds : float = fmod(time, 60.0)
		label.text = "Player %d: %01d:%05.2f" % [playerID, minutes, seconds]
		%BestTime.add_child(label)
	if data_type == DATA_TYPE.LAP_COUNT:
		label.text = "Player %d: %d" % [playerID, PlayerData.lapCount[playerID]]
		%LapCount.add_child(label)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
