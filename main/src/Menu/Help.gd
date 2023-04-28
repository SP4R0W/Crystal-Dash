extends Node


var is_animation_finished: bool = false

var is_switching_page: bool = false

var current_page: int = 0

func _ready():
	$CanvasLayer/TitleLabel.rect_global_position.y = -500
	$CanvasLayer/CreatorLabel.rect_global_position.y = -500
	$CanvasLayer/HelpLabel.modulate.a = 0
	$CanvasLayer/CreditsLabel.modulate.a = 0

	$CanvasLayer/ChangeButton.rect_global_position.x = -500
	$CanvasLayer/QuitButton.rect_global_position.x = -500

	# Animations begin here
	$Tween.interpolate_property($CanvasLayer/TitleLabel,"rect_global_position:y",-500,110,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($CanvasLayer/CreatorLabel,"rect_global_position:y",-500,230,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,0.5)

	$Tween.interpolate_property($CanvasLayer/HelpLabel,"modulate:a",0,1,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1.5)

	$Tween.interpolate_property($CanvasLayer/ChangeButton,"rect_global_position:x",-500,872.5,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,1.5)
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

			$CanvasLayer/HelpLabel.modulate.a = 1

			$CanvasLayer/ChangeButton.rect_global_position.x = 872.5
			$CanvasLayer/QuitButton.rect_global_position.x = 895

			is_animation_finished = true

func _on_QuitButton_pressed():
	if (!is_animation_finished && !is_switching_page):
		return

	Composer.gotoScene(Composer.scenes["mainmenu"])


func _on_ChangeButton_pressed():
	print(!is_animation_finished and is_switching_page)

	if (!is_animation_finished or is_switching_page):
		return

	is_switching_page = true

	if (current_page == 0):
		current_page = 1
		$Tween.interpolate_property($CanvasLayer/CreatorLabel,"modulate:a",1,0,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0.5)
		$Tween.interpolate_property($CanvasLayer/HelpLabel,"modulate:a",1,0,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)

		$Tween.start()
		yield($Tween,"tween_all_completed")

		$CanvasLayer/CreatorLabel.text = "Assets credits:"

		$Tween.interpolate_property($CanvasLayer/CreatorLabel,"modulate:a",0,1,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.interpolate_property($CanvasLayer/CreditsLabel,"modulate:a",0,1,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0.5)

		$Tween.start()
		yield($Tween,"tween_all_completed")

		is_switching_page = false

	elif (current_page == 1):
		current_page = 0

		$Tween.interpolate_property($CanvasLayer/CreatorLabel,"modulate:a",1,0,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0.5)
		$Tween.interpolate_property($CanvasLayer/CreditsLabel,"modulate:a",1,0,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)

		$Tween.start()
		yield($Tween,"tween_all_completed")

		$CanvasLayer/CreatorLabel.text = "How do i play?"

		$Tween.interpolate_property($CanvasLayer/CreatorLabel,"modulate:a",0,1,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.interpolate_property($CanvasLayer/HelpLabel,"modulate:a",0,1,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0.5)

		$Tween.start()
		yield($Tween,"tween_all_completed")

		is_switching_page = false

