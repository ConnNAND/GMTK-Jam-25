extends Control

enum CONTROL_SCEME{KEYBOARD,JOYPAD}

var control_sceme : CONTROL_SCEME
var resume_string : String = "Resume with [%s]"
var quit_string : String = "Quit with [%s]"
var playerID : int = -1

signal quit
# Change Option texts to match proper button
func prepare_menu(pid : int):
	playerID = pid
	if playerID == 99:
		control_sceme = CONTROL_SCEME.KEYBOARD
	elif playerID != -1:
		control_sceme = CONTROL_SCEME.JOYPAD
	
	if control_sceme == CONTROL_SCEME.KEYBOARD:
		%Resume.text = resume_string % "Escape"
		%Quit.text = quit_string % "Backspace"
	if control_sceme == CONTROL_SCEME.JOYPAD:
		%Resume.text = resume_string % "Start"
		%Quit.text = quit_string % "Select"
	

# Read for quit
func _process(delta):
	if not visible:
		return
	if control_sceme == CONTROL_SCEME.KEYBOARD:
		if Input.is_key_pressed(KEY_BACKSPACE):
			quit.emit()
	if control_sceme == CONTROL_SCEME.JOYPAD:
		if Input.is_joy_button_pressed(playerID,JOY_BUTTON_BACK):
			quit.emit()
