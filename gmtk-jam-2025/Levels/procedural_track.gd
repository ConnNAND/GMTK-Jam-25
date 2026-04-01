@tool
extends WorldEnvironment

@export var SEED:String
@export var track_area_radius = 1000
@export var track_area_height = 150
@export var run_from_editor = false

signal apply_track


var newCurve = Curve3D.new()
@export var daily = false


@export var PlayerViewport:PackedScene
@export var Stopwatch:PackedScene
@export var SpeedBuff:PackedScene

var first = null
@onready var music = $Music


func _ready() -> void:
	newCurve.closed = true
	if daily:
		seed(Time.get_date_string_from_system().hash())
	elif SEED==null or SEED=="":
		seed(Time.get_datetime_string_from_system().hash())
	else:
		seed(SEED.hash())
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	
	var points = [Vector2.ZERO]
	var left = randi_range(0, 1)
	for i in randi_range(7, 75):
		var temp
		while true:
			if left==1:
				temp = Vector2(randf_range(-track_area_radius, 0), randf_range(-track_area_radius/2, track_area_radius/2))
			else:
				temp = Vector2(randf_range(0, track_area_radius), randf_range(-track_area_radius/2, track_area_radius/2))
			if !points.has(temp):
				break
		points.append(temp)
	
	#combine points that are too close together
	for i:Vector2 in points:
		for v:Vector2 in points:
			if i.distance_to(v)<60 and i!=v:
				points.erase(v)
	#order the exterior points
	points = Geometry2D.convex_hull(points)
	points[0].y -= 10
	points[points.size()-1].y += 10
	
	#add more curves between longer stretches
	for i in range(points.size()):
		var temp = points[i].distance_to(points[wrapi(i+1, 0, points.size()-1)])
		if temp>128:
			var temp2 = (points[i]+points[wrapi(i+1, 0, points.size()-1)])/2
			temp2.x += randf_range(-temp/4, temp/4)
			temp2.y += randf_range(-temp/4, temp/4)
			points.insert(wrapi(i+1, 0, points.size()-1), temp2)
			i += 1
	
	#add more points between to smooth out changes in elevation
	for i in range(points.size()):
		var temp = points[i].distance_to(points[wrapi(i+1, 0, points.size()-1)])
		if temp>120:
			var temp2 = (points[i]+points[wrapi(i+1, 0, points.size()-1)])/2
			points.insert(wrapi(i+1, 0, points.size()-1), temp2)
			i += 1
	
	#erase duplicate points
	var newpoints = []
	for i in points:
		if !newpoints.has(i):
			newpoints.append(Vector3(i.x, noise.get_noise_2dv(i/4)*track_area_height, i.y))
	points = newpoints
	
	#apply points to curve
	for i in range(points.size()):
		var curPoint:Vector3 = points[i]
		var nextPoint:Vector3 = points[wrapi(i+1, 0, points.size())]
		var prevPoint:Vector3 = points[wrapi(i-1, 0, points.size())]
		var curveOut:Vector3 = (nextPoint-curPoint).normalized() * curPoint.distance_to(nextPoint)/4
		var curveIn = -curveOut.normalized()*curPoint.distance_to(prevPoint)/4
		newCurve.add_point(curPoint, curveIn, curveOut)
	$Path3D.curve = newCurve
	
	#add obstacles
	apply_track.emit()
	
	#This is the part where we actually do game logic now and spawn in players
	$Spawn.global_transform.origin = $Spawn/RayCast3D.get_collision_point()+Vector3(0, 5, 0)
	for i in PlayerData.players:
		var temp = PlayerViewport.instantiate()
		$PlayerViews.add_child(temp)
		temp.ready_player(i, $Spawn.global_transform.origin+Vector3(randf_range(-10, 10), randf_range(0, 10), randf_range(-10, 10)))
		var temp2 = Stopwatch.instantiate()
		$Path3D.add_child(temp2)
		temp2.player_id = i[0]
		temp2.reset()
		var temp3 = SpeedBuff.instantiate()
		$Path3D.add_child(temp3)
		temp3.player_id = i[0]
		temp3.reset()
	$PlayerViews.columns = maxi(ceili(sqrt($PlayerViews.get_child_count())), 1)
	$AudioStreamPlayer.play()


func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		music.volume_db = move_toward(music.volume_db, min(-20, first.windspeed*-30), delta*5)#-20 - (first.windspeed)


func start_game():
	find_child("StartingBlock").queue_free()
	$PlayerViews.start_game()
	$Music.play()
	for i in get_tree().get_nodes_in_group("GameTimer"):
		i.resume_game_timer()


func _on_music_finished() -> void:
	$Music.play()
