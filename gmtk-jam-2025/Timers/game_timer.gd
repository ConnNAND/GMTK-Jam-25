class_name GameTimer extends Label

# Stopwatch Timer
var _stopwatch_display : String = "Time: %01d:%05.2f" #m:ss.ll
var _stopwatch_timer : Timer
signal stopwatch_timer_timeout

# Overtime Timer
@export var initial_overtime : float = 0.001
var _overtime_display : String = "+ %01d:%05.2f OVERTIME" #m:ss.ll
var _overtime_timer : Timer
signal overtime_timer_timeout

# Personal Best
var _pb_display : String = "Best: %01d:%05.2f" #m:ss.ll
@export var initial_pb_seconds : float = 240.0
var _pb_seconds : float = 0.0

func _ready():
	# Set the default personal best
	set_pb(initial_pb_seconds)
	# Create Stopwatch Timer
	_stopwatch_timer = Timer.new()
	_stopwatch_timer.one_shot = true
	_stopwatch_timer.paused = true
	_stopwatch_timer.timeout.connect(_on_stopwatch_timer_timeout)
	add_child(_stopwatch_timer)
	start_stopwatch()
	%StopwatchTimer.text = _get_timer_string(0.0,_stopwatch_display)
	# Create Overtime Timer
	_overtime_timer = Timer.new()
	_overtime_timer.one_shot = true
	_overtime_timer.wait_time = initial_overtime
	_overtime_timer.paused = true
	_overtime_timer.timeout.connect(_on_overtime_timer_timeout)
	add_child(_overtime_timer)
	_overtime_timer.start()
	%OvertimeTimer.text = _get_timer_string(_get_overtime(),_overtime_display)

# Updates the text to match the current timer
func _process(_delta):
	%OvertimeTimer.text = _get_timer_string(_get_overtime(), _overtime_display)
	%StopwatchTimer.text = _get_timer_string(_get_stopwatch_time(),_stopwatch_display)

# When you cross the goal posts, updates
# the personal best to the current time
func cross_goal_post():
	# Pause timers
	if _overtime_timer.paused:
		# Get current stopwatch time
		var stopwatch_time : float = _get_stopwatch_time()
		# Get the time to add to overtime
		var overtime : float = _stopwatch_timer.time_left / 2
		print("you beat your best by %05.2f seconds!" % overtime)
		# Add the overtime to the overtime timer
		add_overtime(overtime)
		# Update the PB
		set_pb(stopwatch_time)
	else:
		pause_overtime_timer()
	# Start the timer with new PB
	start_stopwatch()

# Starts the game timer from wherever its at
func resume_game_timer():
	if _stopwatch_timer.time_left != 0.0:
		resume_stopwatch_timer()
	else:
		resume_overtime_timer()

# Starts the game timer from wherever its at
func pause_game_timer():
	if _stopwatch_timer.time_left != 0.0:
		pause_stopwatch_timer()
	else:
		pause_overtime_timer()

# Start the stopwatch timer
func start_stopwatch(): _stopwatch_timer.start(_pb_seconds)
# Pause the overtime timer
func pause_stopwatch_timer(): _stopwatch_timer.paused = true
# Resume the overtime timer
func resume_stopwatch_timer(): _stopwatch_timer.paused = false

# Pause the overtime timer
func pause_overtime_timer(): _overtime_timer.paused = true
# Resume the overtime timer
func resume_overtime_timer(): _overtime_timer.paused = false
# Adds time to the overtime timer
func add_overtime(time : float): _overtime_timer.start(_get_overtime() + time)

func set_pb(new_time : float):
	_pb_seconds = new_time
	%PersonalBest.text = _get_timer_string(new_time,_pb_display)

func _get_timer_string(time : float, format_string : String) -> String:
	var minutes : float = floorf(time / 60.0)
	var seconds : float = fmod(time, 60.0)
	return format_string % [minutes,seconds]

func _get_stopwatch_time() -> float: return _pb_seconds - _stopwatch_timer.time_left

func _get_overtime() -> float: return _overtime_timer.time_left

# Must freeze when it reaches the personal best,
# starting the overtime timer
func _on_stopwatch_timer_timeout():
	print("you reached your best :0")
	stopwatch_timer_timeout.emit()
	resume_overtime_timer()

# Calls the correct timeout when the private lap timer ends
func _on_overtime_timer_timeout():
	print("ran out of time!")
	overtime_timer_timeout.emit()
