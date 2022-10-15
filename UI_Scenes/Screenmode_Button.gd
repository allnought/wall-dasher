extends OptionButton


func _ready():
	if OS.window_borderless:
		self.text = "Borderless"
	elif OS.window_fullscreen:
		self.text = "Fullscreen"
	else:
		self.text = "Windowed"
