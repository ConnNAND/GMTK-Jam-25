extends WorldEnvironment

@export var PlayerViewport:PackedScene
@export var Stopwatch:PackedScene
@export var SpeedBuff:PackedScene

func _ready() -> void:
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

func start_game():
	find_child("StartingBlock").queue_free()
	for i in get_tree().get_nodes_in_group("GameTimer"):
		i.resume_game_timer()
