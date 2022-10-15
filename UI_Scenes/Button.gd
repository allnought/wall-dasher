extends Button

func _ready():
	self.connect("pressed", self, "button_pressed")

func button_pressed():
	get_tree().paused = false
	self.get_parent().get_parent().visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
