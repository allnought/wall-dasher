extends DirectionalLight


var config = ConfigFile.new()


func _ready():
	config.load("res://settings.cfg")
	if config.get_value("graphics", "lighting", true) == false:
		self.queue_free()
