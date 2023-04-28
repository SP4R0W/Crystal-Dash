extends Node

var is_animation_finished: bool = false

var is_browser_game: bool = false

func _ready():
	if (OS.get_name() == "HTML5"):
		is_browser_game = true

	$CanvasLayer/TitleLabel.rect_global_position.y = -500
	$CanvasLayer/CreatorLabel.rect_global_position.y = -500

	$CanvasLayer/PlayButton.rect_global_position.x = -500
	$CanvasLayer/HiButton.rect_global_position.x = -500
	$CanvasLayer/HelpButton.rect_global_position.x = -500
	$CanvasLayer/OptionsButton.rect_global_position.x = -500
	$CanvasLayer/QuitButton.rect_global_position.x = -500

	# Hide the exit button on browser version
	if (is_browser_game):
		$CanvasLayer/QuitButton.visible = false

	# Animations begin here
	$Tween.interpolate_property($CanvasLayer/TitleLabel,"rect_global_position:y",-500,0,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($CanvasLayer/CreatorLabel,"rect_global_position:y",-500,275,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,0.5)

	$Tween.interpolate_property($CanvasLayer/PlayButton,"rect_global_position:x",-500,870,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,1.5)

	$Tween.interpolate_property($CanvasLayer/HiButton,"rect_global_position:x",-500,815,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,1.75)

	$Tween.interpolate_property($CanvasLayer/HelpButton,"rect_global_position:x",-500,895,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,2)

	$Tween.interpolate_property($CanvasLayer/OptionsButton,"rect_global_position:x",-500,855,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,2.25)

	$Tween.interpolate_property($CanvasLayer/QuitButton,"rect_global_position:x",-500,895,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,2.5)

	$Tween.start()

	yield($Tween,"tween_all_completed")

	var theme = get_parent().get_node("MenuTheme")
	if (theme.playing == false and Global.is_music_on):
		theme.play()

	is_animation_finished = true

func _input(event):
	if (event is InputEventMouseButton):
		if (event.is_pressed() && event.button_index == 1 && !is_animation_finished):
			$Tween.remove_all()

			$CanvasLayer/TitleLabel.rect_global_position.y = 0
			$CanvasLayer/CreatorLabel.rect_global_position.y = 275

			$CanvasLayer/PlayButton.rect_global_position.x = 870
			$CanvasLayer/HiButton.rect_global_position.x = 815
			$CanvasLayer/HelpButton.rect_global_position.x = 895
			$CanvasLayer/OptionsButton.rect_global_position.x = 855
			$CanvasLayer/QuitButton.rect_global_position.x = 895

			is_animation_finished = true

			var theme = get_parent().get_node("MenuTheme")
			if (theme.playing == false and Global.is_music_on):
				theme.play()

func _on_PlayButton_pressed():
	if (!is_animation_finished):
		return

	Composer.gotoScene(Composer.scenes["game"])

func _on_HiButton_pressed():
	if (!is_animation_finished):
		return

	Composer.gotoScene(Composer.scenes["highscores"])

func _on_HelpButton_pressed():
	if (!is_animation_finished):
		return

	Composer.gotoScene(Composer.scenes["help"])

func _on_OptionsButton_pressed():
	if (!is_animation_finished):
		return

	Composer.gotoScene(Composer.scenes["options"])

func _on_QuitButton_pressed():
	get_tree().quit()
