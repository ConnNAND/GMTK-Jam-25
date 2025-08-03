extends GridContainer

@export var player_select:PackedScene
@export var MainMenu:PackedScene

func _ready() -> void:
	$"../../../AudioStreamPlayer".play()
	$"../AddPlayer".grab_focus()

#func _unhandled_input(event: InputEvent) -> void:
#	print(event.device)
#	if players_entered.find(event.device) == -1 and event is InputEventJoypadButton:
#		if event.button_index==JOY_BUTTON_START and event.is_pressed():
#			players_entered.append(event.device)
#			var temp = player_select.instantiate()
#			add_child(temp)
#			columns = ceili(sqrt(players_entered.size()))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_add_player_pressed() -> void:
	var temp = player_select.instantiate()
	add_child(temp)
	columns = ceili(sqrt(get_child_count()))


func _on_start_pressed() -> void:
	var temp = []
	if get_children().size() > 0:
		for i in get_children():
			temp.append([i.player_id, i.character])
		PlayerData.load_players(temp)
		get_tree().change_scene_to_file("res://Levels/test_room.tscn")
