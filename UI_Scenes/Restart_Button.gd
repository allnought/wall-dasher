extends Button


func _ready():
	connect("pressed", self, "_button_pressed")


func _button_pressed():
	match(int(get_tree().get_current_scene().get_name())):
		1:
			get_tree().change_scene("res://Levels/2.tscn")
		2:
			get_tree().change_scene("res://Levels/3.tscn")
	get_tree().paused = false


func _on_NextLevel_Button_visibility_changed():
	grab_focus()
