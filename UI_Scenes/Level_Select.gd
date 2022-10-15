extends Control


func _ready():
	get_node("ColorRect/VBoxContainer/HBoxContainer/1").grab_focus()

func _on_1_pressed():
	get_tree().change_scene("res://Levels/1.tscn")

func _on_4_pressed():
	get_tree().change_scene("res://UI_Scenes/StartMenu.tscn")


func _on_2_pressed():
	get_tree().change_scene("res://Levels/2.tscn")


func _on_3_pressed():
	get_tree().change_scene("res://Levels/3.tscn")
