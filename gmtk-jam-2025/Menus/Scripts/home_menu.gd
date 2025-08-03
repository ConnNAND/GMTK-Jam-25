extends CenterContainer

func _ready() -> void:
	$MainMenu/Play.grab_focus()


func _on_play_pressed() -> void:
	$MainMenu.visible = false
	$ModeSelect.visible = true
	$ModeSelect/LocalGame.grab_focus()


func _on_help_pressed() -> void:
	$MainMenu.visible = false
	$Help.visible = true
	$Help/Back.grab_focus()


func _on_options_pressed() -> void:
	$MainMenu.visible = false
	$Options.visible = true
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
	get_tree().change_scene_to_file("res://Menus/character_select.tscn")


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
