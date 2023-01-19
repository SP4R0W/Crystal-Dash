extends Node

func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		var key = OS.get_scancode_string(event.scancode)
		if key == "Q" && event.is_pressed():
			get_tree().quit()
