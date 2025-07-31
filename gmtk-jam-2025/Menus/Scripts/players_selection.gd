extends GridContainer

var players_entered = []
@export var player_select:PackedScene
@export var MainMenu:PackedScene

func _ready() -> void:
	$"../Back".grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if players_entered.find(event.device) == null and event is InputEventJoypadButton:
		if event.button_index==JOY_BUTTON_START:
			players_entered.append(event.device)
			var temp = player_select.instantiate()
			temp.player_id = event.device
			add_child(temp)
			columns = ceili(sqrt(players_entered.size()))


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
