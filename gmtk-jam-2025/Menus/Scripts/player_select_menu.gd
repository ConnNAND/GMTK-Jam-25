extends CenterContainer

var player_id = 0
var character:int

func _ready() -> void:
	for i in Input.get_connected_joypads():
		$VBoxContainer/Controller.add_item(Input.get_joy_name(i), i)

#func _unhandled_input(event: InputEvent) -> void:
#	if event.device == player_id and event is InputEventJoypadButton:
#		if event.button_index==JOY_BUTTON_DPAD_UP and event.is_pressed():
#			if focused.focus_neighbor_top!=null:
#				get_node(focus_neighbor_top).grab_focus()
#				focused = get_node(focus_neighbor_top)
#		elif event.button_index==JOY_BUTTON_DPAD_DOWN and event.is_pressed():
#			if focused.focus_neighbor_bottom!=null:
#				get_node(focus_neighbor_bottom).grab_focus()
#				focused = get_node(focus_neighbor_bottom)
#		elif event.button_index==JOY_BUTTON_DPAD_LEFT and event.is_pressed():
#			if focused.focus_neighbor_left!=null:
#				get_node(focus_neighbor_left).grab_focus()
#				focused = get_node(focus_neighbor_left)
#		elif event.button_index==JOY_BUTTON_DPAD_RIGHT and event.is_pressed():
#			if focused.focus_neighbor_right!=null:
#				get_node(focus_neighbor_right).grab_focus()
#				focused = get_node(focus_neighbor_right)


func _on_controller_item_selected(index: int) -> void:
	player_id = $VBoxContainer/Controller.get_item_id(index)


func _on_leave_pressed() -> void:
	get_parent().columns = maxi(ceili(sqrt(get_child_count())), 1)
	queue_free()
	$"../../AddPlayer".grab_focus()


func _on_character_item_selected(index: int) -> void:
	character = index
