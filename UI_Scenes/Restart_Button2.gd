extends Button


func _ready():
	connect("pressed", self, "_button_pressed")


func _button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false


func _on_Restart_Button_visibility_changed():
	grab_focus()
