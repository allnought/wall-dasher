extends Control

var config = ConfigFile.new()
onready var ssao_button = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer/SSAO_Button")
onready var screen_mode_button = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer/Screenmode_Button")
onready var bloom_button = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer/Bloom_Button")
onready var light_button = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer/Light_Button")
onready var exit_button = get_node("ColorRect/VBoxContainer/Exit")
onready var msaa_button = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer/MSAA_Container/MSAA_Button")
onready var dof_button = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer/DOF_Button")
onready var mouse_sens = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer2/Mouse_Sens_Slider")
onready var joy_sens = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer2/Joy_Sens_Slider")
onready var invert_button = get_node("ColorRect/VBoxContainer/HBoxContainer/VBoxContainer2/Invert_Button")

func _ready():
	exit_button.grab_focus()
	var err = config.load("res://settings.cfg")
	if err != OK:
		return
	else:
		ssao_button.pressed = config.get_value("graphics", "ssao", false)
		screen_mode_button.selected = config.get_value("video", "screen_mode", 0)
		bloom_button.pressed = config.get_value("graphics", "bloom", false)
		light_button.pressed = config.get_value("graphics", "lighting", true)
		dof_button.pressed = config.get_value("graphics", "dof", false)
		mouse_sens.value = config.get_value("gameplay", "mouse_sens", 0.05)
		joy_sens.value = config.get_value("gameplay", "joy_sens", 170)
		invert_button.pressed = config.get_value("gameplay", "invert", false)
		msaa_button.selected = config.get_value("graphics", "msaa", 0)
		

func _on_Exit_pressed():
	get_tree().change_scene("res://UI_Scenes/StartMenu.tscn")	
	config.save("res://settings.cfg")

func _on_Vsync_Button_toggled(toggle):
	config.set_value("video", "vsync", toggle)

func _on_Screenmode_Button_item_selected(index):
	config.set_value("video", "screen_mode", index)

func _on_SSAO_Button_toggled(toggle):
	config.set_value("graphics", "ssao", toggle)

func _on_CheckButton_toggled(toggle):
	config.set_value("graphics", "bloom", toggle)

func _on_Light_Button_toggled(toggle):
	config.set_value("graphics", "lighting", toggle)

func _on_DOF_Button_toggled(toggle):
	config.set_value("graphics", "dof", toggle)

func _on_MSAA_Button_item_selected(index):
	config.set_value("graphics", "msaa", index)

func _on_Mouse_Sens_Slider_value_changed(value):
	config.set_value("gameplay", "mouse_sens", value)

func _on_HSlider_value_changed(value):
	config.set_value("gameplay", "joy_sens", value)

func _on_Invert_Button_toggled(toggle):
	config.set_value("gameplay", "invert", toggle) 

