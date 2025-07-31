extends WorldEnvironment

@export var PlayerViewport:PackedScene

func _ready() -> void:
	for i in PlayerData.players:
		var temp = PlayerViewport.instantiate()
		$PlayerViews.add_child(temp)
		temp.ready_player(i, $Spawn.global_transform.origin+Vector3(randf_range(-10, 10), randf_range(0, 10), randf_range(-10, 10)))
	$PlayerViews.columns = maxi(ceili(sqrt($PlayerViews.get_child_count())), 1)
