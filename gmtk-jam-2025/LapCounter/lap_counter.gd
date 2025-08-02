class_name LapCounter extends Label

var lap_display : String = "Laps: %d"
var laps : int = 0

func _process(delta):
	text = lap_display % [laps]

func increment():
	laps += 1
