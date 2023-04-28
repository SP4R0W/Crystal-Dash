extends Node

var is_animation_finished: bool = false

func _ready():
	load_highscores()

	$CanvasLayer/TitleLabel.rect_global_position.y = -500
	$CanvasLayer/CreatorLabel.rect_global_position.y = -500

	$CanvasLayer/ScoresLabel.modulate.a = 0

	$CanvasLayer/QuitButton.rect_global_position.x = -500

	# Animations begin here
	$Tween.interpolate_property($CanvasLayer/TitleLabel,"rect_global_position:y",-500,110,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($CanvasLayer/CreatorLabel,"rect_global_position:y",-500,230,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,0.5)

	$Tween.interpolate_property($CanvasLayer/ScoresLabel,"modulate:a",0,1,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1.5)

	$Tween.interpolate_property($CanvasLayer/QuitButton,"rect_global_position:x",-500,895,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,1.5)

	$Tween.start()

	yield($Tween,"tween_all_completed")

	is_animation_finished = true

func _input(event):
	# Skip animations on mouse press
	if (event is InputEventMouseButton):
		if (event.is_pressed() && event.button_index == 1 && !is_animation_finished):
			$Tween.remove_all()

			$CanvasLayer/TitleLabel.rect_global_position.y = 110
			$CanvasLayer/CreatorLabel.rect_global_position.y = 230

			$CanvasLayer/ScoresLabel.modulate.a = 1

			$CanvasLayer/QuitButton.rect_global_position.x = 895

			is_animation_finished = true

func load_highscores():
	$CanvasLayer/ScoresLabel.text = "1. Level: " + str(Global.highscores[1]["level"]) + "; Score: " + str(Global.highscores[1]["score"]) + "\n2. Level: " + str(Global.highscores[2]["level"]) + "; Score: " + str(Global.highscores[3]["score"]) + "\n3. Level: " + str(Global.highscores[3]["level"]) + "; Score: " + str(Global.highscores[3]["score"]) + "\n4. Level: " + str(Global.highscores[4]["level"]) + "; Score: " + str(Global.highscores[4]["score"]) + "\n5. Level: " + str(Global.highscores[5]["level"]) + "; Score: " + str(Global.highscores[5]["score"]) + "\n6. Level: " + str(Global.highscores[6]["level"]) + "; Score: " + str(Global.highscores[6]["score"]) + "\n7. Level: " + str(Global.highscores[7]["level"]) + "; Score: " + str(Global.highscores[7]["score"]) + "\n8. Level: " + str(Global.highscores[8]["level"]) + "; Score: " + str(Global.highscores[8]["score"]) + "\n9. Level: " + str(Global.highscores[9]["level"]) + "; Score: " + str(Global.highscores[9]["score"]) + "\n10. Level: " + str(Global.highscores[10]["level"]) + "; Score: " + str(Global.highscores[10]["score"])

func _on_QuitButton_pressed():
	if (!is_animation_finished):
		return

	Composer.gotoScene(Composer.scenes["mainmenu"])
