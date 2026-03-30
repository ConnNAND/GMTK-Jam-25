@tool
extends WorldEnvironment

@export var SEED:String
@export var track_area_radius = 500
@export var track_area_height = 100


var newCurve = Curve3D.new()
@export var daily = false

func _ready() -> void:
	newCurve.closed = true
	if daily:
		seed(Time.get_date_string_from_system().hash())
	if SEED==null or SEED=="":
		seed(Time.get_datetime_string_from_system().hash())
	else:
		seed(SEED.hash())
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	
	var points = [Vector2.ZERO]
	var left = randi_range(0, 1)
	for i in randi_range(7, 125):
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
	
	#erase duplicate points
	var newpoints = []
	for i in points:
		if !newpoints.has(i):
			newpoints.append(Vector3(i.x, noise.get_noise_2dv(i)*track_area_height, i.y))
	points = newpoints
	
	for i in range(points.size()):
		var curPoint:Vector3 = points[i]
		var nextPoint:Vector3 = points[wrapi(i+1, 0, points.size())]
		var prevPoint:Vector3 = points[wrapi(i-1, 0, points.size())]
		var curveOut:Vector3 = (nextPoint-curPoint).normalized() * curPoint.distance_to(nextPoint)/4
		var curveIn = -curveOut.normalized()*curPoint.distance_to(prevPoint)/4
		newCurve.add_point(curPoint, curveIn, curveOut)
	$Path3D.curve = newCurve
