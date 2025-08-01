class_name OvertimeTimer extends Label

@export var initial_overtime : float = 0.001
var _overtime_display : String = "+ %01d:%05.2f OVERTIME" #m:ss.ll
var _overtime_timer : Timer

signal overtime_timer_timeout

# Starts the timer whenever ready
func start_overtime_timer():
	_overtime_timer.start()

# Adds time to the timer
func add_time(time : float):
	if _overtime_timer.is_stopped():
		_overtime_timer.wait_time += time
	elif _overtime_timer.paused:
		_overtime_timer.start(_overtime_timer.time_left + time)

# Pause the overtime timer
func pause_overtime_timer():
	_overtime_timer.paused = true

# Resume the overtime timer
func resume_overtime_timer():
	_overtime_timer.paused = false

# Sets the text for the initial lap time
func _ready():
	_overtime_timer = Timer.new()
	_overtime_timer.wait_time = initial_overtime
	_overtime_timer.one_shot = true
	_overtime_timer.timeout.connect(_on_overtime_timer_timeout)
	add_child(_overtime_timer)

# Updates the text to match the current timer
func _process(_delta):
	text = _get_timer_string()

func _get_timer_string() -> String:
	var time_left : float = _overtime_timer.time_left
	var minutes : float = floorf(time_left / 60.0)
	var seconds : float = fmod(time_left, 60.0)
	return _overtime_display % [minutes,seconds]

# Calls the correct timeout when the private lap timer ends
func _on_overtime_timer_timeout():
	print("ran out of time!")
	overtime_timer_timeout.emit()
