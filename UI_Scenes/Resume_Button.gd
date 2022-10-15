extends Button


func _ready():
	connect("pressed", self, "_button_pressed")
	print(get_tree().get_current_scene().get_name())


func _on_Resume_Button_visibility_changed():
	grab_focus()


func _button_pressed():
	get_parent().get_parent().get_parent().get_parent().visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
