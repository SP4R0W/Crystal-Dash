extends Area2D

signal gem_clicked(gem)

func _on_Gem_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() && Global.can_interact):
		emit_signal("gem_clicked",self)

