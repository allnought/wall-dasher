extends Control


func _ready():
	pass



func _on_Button2_pressed():
	get_tree().reload_current_scene()

func _on_Button_pressed():
	get_tree().change_scene("res://UI_Scenes/StartMenu.tscn")
