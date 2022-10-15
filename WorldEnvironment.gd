extends WorldEnvironment

var settings = {}
var config = ConfigFile.new()


func _ready():
	config.load("res://settings.cfg")
	for setting in config.get_sections():
		match config.get_value(setting, "ssao", false):
			false:
				self.environment.ssao_enabled = false 
			true:
				self.environment.ssao_enabled = true
		if config.get_value("graphics", "bloom", false) == true:
			self.environment.glow_enabled = true
		else:
			self.environment.glow_enabled = false
		if config.get_value("graphics", "dof", false) == true:
			self.environment.dof_blur_far_enabled = true
		else:
			self.environment.dof_blur_far_enabled = false 
		match config.get_value("graphics", "msaa", 0):
			0: get_viewport().msaa = Viewport.MSAA_DISABLED
			1: get_viewport().msaa = Viewport.MSAA_2X
			2: get_viewport().msaa = Viewport.MSAA_4X
			3: get_viewport().msaa = Viewport.MSAA_8X
			4: get_viewport().msaa = Viewport.MSAA_16X

