extends Label

var time = 10

func _process(delta: float) -> void:
	time -= delta
	text = "Game Begins In " + str(roundi(time))
	if time <= 0:
		get_parent().start_game()
		queue_free()
