extends Button

func _ready():
	self.connect("pressed", self, "button_pressed")

func button_pressed():
	get_tree().quit()
