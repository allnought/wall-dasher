extends Control

var pause = false

func _input(event):
	if event.is_action_pressed("pause"):
		if pause == false and Input.is_action_just_pressed("pause"): pause = true
		elif Input.is_action_just_pressed("pause"): pause = false

		if pause:
			get_tree().paused = true
			visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			self.get_child(1).get_child(1).grab_focus()
		else:
			get_tree().paused = false
			visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
