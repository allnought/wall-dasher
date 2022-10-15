extends Spatial

func _on_Area_body_entered(body:Node):
	if body.name == "Player":
		var level = Level.new()
		level.level_3 = true
		level.level_2 = true
		var result = ResourceSaver.save("res://save_data.res", level)
		assert(result == OK)
		get_tree().paused = true
		get_node("Win").visible = true
