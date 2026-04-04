extends CenterContainer

func _ready() -> void:
	$MainMenu/Play.grab_focus()
	$"../../AudioStreamPlayer".play()
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		get_window().content_scale_factor = 3.0 


func _on_play_pressed() -> void:
	$MainMenu.visible = false
	$ModeSelect.visible = true
	$"../../click".play()
	$ModeSelect/LocalGame.grab_focus()


func _on_help_pressed() -> void:
	$MainMenu.visible = false
	$Help.visible = true
	$"../../click".play()
	$Help/Back.grab_focus()


func _on_options_pressed() -> void:
	$MainMenu.visible = false
	$Options.visible = true
	$"../../click".play()
	AudioServer.get_bus_volume_linear(0)
	$Options/Volume.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _modeselect_on_back_pressed() -> void:
	$ModeSelect.visible = false
	$MainMenu.visible = true
	$MainMenu/Play.grab_focus()


func _help_on_back_pressed() -> void:
	$Help.visible = false
	$MainMenu.visible = true
	$MainMenu/Play.grab_focus()

func _options_on_back_pressed() -> void:
	$Options.visible = false
	$MainMenu.visible = true
	$MainMenu/Play.grab_focus()


func _on_local_game_pressed() -> void:
	PlayerData.current_mode = PlayerData.mode.local
	get_tree().change_scene_to_file("res://Menus/character_select.tscn")


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)


func _on_daily_track_pressed() -> void:
	PlayerData.current_mode = PlayerData.mode.daily
	get_tree().change_scene_to_file("res://Menus/character_select.tscn")
