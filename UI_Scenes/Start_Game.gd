extends Button

func _ready():
	self.connect("pressed", self, "button_pressed")
	grab_focus()

func button_pressed():
	get_tree().change_scene("res://UI_Scenes/Level_Select.tscn")
