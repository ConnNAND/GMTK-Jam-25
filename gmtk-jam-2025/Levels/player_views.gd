extends Node

func check_over():
	if get_child_count() == 0:
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
