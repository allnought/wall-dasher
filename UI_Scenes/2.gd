extends Button


func _ready():
	if ResourceLoader.exists("res://save_data.res"):
		var level = ResourceLoader.load("res://save_data.res")
		if level.level_2 == true:
			disabled = false

