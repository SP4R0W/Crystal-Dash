extends Area2D

signal gem_clicked(gem)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Gem_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() && Global.can_interact:
		emit_signal("gem_clicked",self)
		
