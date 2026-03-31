@tool
extends WorldEnvironment

@export var SEED:String
var int_seed : int
@export var track_radius = 100
@export var track_radius_variation = 20
@export var track_height_variation = 50
@export var track_sample_count = 100
@export var heightNoise : FastNoiseLite = FastNoiseLite.new()
@export var curveNoise : FastNoiseLite = FastNoiseLite.new()
@export var daily = false
@export var reload : bool = false:
	set(value):
		setup()
		reload = false

func setup() -> void:
	var newCurve = Curve3D.new()
	newCurve.closed = false
	if daily:
		seed(Time.get_date_string_from_system().hash())
	if SEED==null or SEED=="":
		seed(Time.get_datetime_string_from_system().hash())
	else:
		seed(SEED.hash())
	
	heightNoise.seed = randi()
	curveNoise.seed = randi()
	
	# Get a normalized list of seamless noise values
	var heightMap : Array[float] = normalize_image_data(heightNoise.get_seamless_image(track_sample_count,1))
	var curveMap : Array[float] = normalize_image_data(curveNoise.get_seamless_image(track_sample_count,1))
	
	var offsets : Array[Vector2] = []
	offsets.resize(track_sample_count)
	for i in offsets.size():
		offsets[i] = Vector2((curveMap[i] * 2 - 1) * track_radius_variation, (heightMap[i] * 2 - 1) * track_height_variation)
	
	# Create a curve with a circle shape
	
	for i in track_sample_count:
		var track_progress : float = PI * i * 2.0 / (track_sample_count)
		newCurve.add_point(Vector3(cos(track_progress) * (track_radius - offsets[i].x), offsets[i].y,sin(track_progress) * (track_radius - offsets[i].x)))
	
	%Path3D.curve = newCurve

func _ready() -> void:
	setup()

func normalize_image_data(image : Image) -> Array[float]:
	var data : PackedByteArray = image.data["data"]
	var normalized_data : Array[float]
	normalized_data.resize(data.size())
	for i in data.size():
		normalized_data[i] = data[i] / 255.0
	return normalized_data
