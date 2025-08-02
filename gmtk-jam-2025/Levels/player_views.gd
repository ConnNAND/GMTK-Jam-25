extends Node

func check_over():
	var game_over = true
	for i in get_children():
		if i.finished:
			continue
		else:
			game_over = false
			break
	if game_over:
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
