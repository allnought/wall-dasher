extends Button


func _ready():
	connect("pressed", self, "_button_pressed")


func _button_pressed():
	get_tree().change_scene("res://UI_Scenes/StartMenu.tscn")
	get_tree().paused = false
