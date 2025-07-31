extends GridContainer

var players_entered = []
@export var player_select:PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if players_entered.find(event.device) == null and event is InputEventJoypadButton:
		if event.button_index==JOY_BUTTON_START:
			players_entered.append(event.device)
			var temp = player_select.instantiate()
			add_child(temp)
			columns = ceili(sqrt(players_entered.size()))
