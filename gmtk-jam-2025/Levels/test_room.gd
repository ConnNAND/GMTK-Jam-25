extends WorldEnvironment

@export var PlayerViewport:PackedScene

func _ready() -> void:
	$PlayerViews.columns = maxi(ceili(sqrt(get_child_count())), 1)
	for i in PlayerData.players:
		var temp = PlayerViewport.instantiate()
		$PlayerViews.add_child(temp)
		temp.ready_player(Vector2i(get_viewport().size/$PlayerViews.columns), i, $Spawn.global_transform.origin+Vector3(randf_range(-10, 10), randf_range(0, 10), randf_range(-10, 10)))
