extends Control

var settings = {}
var config = ConfigFile.new()


func _ready():
	config.load("res://settings.cfg")
	for setting in config.get_sections():
		print(config.get_value("video", "screen_mode", 0))
		match config.get_value("video", "screen_mode", 0):
			0: 
				OS.window_minimized = true
				OS.window_fullscreen = false
				OS.window_borderless = false
			null: 
				OS.window_minimized = true
				OS.window_fullscreen = false
				OS.window_borderless = false
			1:
				OS.window_minimized = false 
				OS.window_fullscreen = true 
				OS.window_borderless = false
			2:
				OS.window_minimized = false 
				OS.window_fullscreen = false
				OS.window_borderless = true 
		OS.vsync_enabled = config.get_value(setting, "vsync", true)

func _on_Options_pressed():
	get_tree().change_scene("res://UI_Scenes/Options.tscn")
