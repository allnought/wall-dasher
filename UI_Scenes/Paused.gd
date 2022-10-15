extends Control


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if visible == false:
			visible = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else: 
			visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false

