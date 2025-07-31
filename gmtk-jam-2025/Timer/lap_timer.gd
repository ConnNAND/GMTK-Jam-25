class_name LapTimer extends Label

@export var initial_lap_time : float = 10.0 :
	set(time):
		text = str(roundf(time * 100) / 100.0)
		initial_lap_time = time

var _lap_timer : SceneTreeTimer
signal lap_timer_timeout

# Sets the text for the initial lap time
func _ready():
	text = str(roundf(initial_lap_time * 100) / 100.0)

# Updates the text to match the current timer
func _process(_delta):
	if(_lap_timer != null):
		text = str(roundf(_lap_timer.time_left * 100) / 100.0)

# Starts the timer whenever ready
func start_timer():
	_lap_timer = get_tree().create_timer(initial_lap_time)
	_lap_timer.timeout.connect(_on_lap_timer_timeout)

# Adds time to the timer
func add_time(time : float):
	# If the timer is null, add the time to the initial lap time
	if (_lap_timer == null):
		initial_lap_time += time
	# Otherwise, add the time to the current time left and
	# Create a new timer
	else:
		var new_time_left : float = _lap_timer.time_left + time
		if (_lap_timer.is_connected("timeout",_on_lap_timer_timeout)):
			_lap_timer.disconnect("timeout",_on_lap_timer_timeout)
		_lap_timer = get_tree().create_timer(new_time_left)
		_lap_timer.timeout.connect(_on_lap_timer_timeout)

# Calls the correct timeout when the private lap timer ends
func _on_lap_timer_timeout():
	print("ran out of time!")
	lap_timer_timeout.emit()
