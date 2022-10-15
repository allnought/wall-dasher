extends Spatial

func _on_Area_body_entered(body:Node):
	if body.name == "Player":
		get_tree().change_scene("res://Levels/4.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
