class_name Speedometer extends Label

var speed_display : String = "Speed: %05.2f m/s"
var target : CharacterBody3D
func _process(delta):
	if target != null: 
		text = speed_display % [target.velocity.length()]
