extends Node

var is_animation_finished = false

var is_new_highscore = false

var new_highscore_place = 0

func _ready():
	check_for_highscore()
	
	$CanvasLayer/TitleLabel.rect_global_position.y = -500
	$CanvasLayer/CreatorLabel.rect_global_position.y = -500
	
	$CanvasLayer/TimeText.rect_global_position.x = -1920
	$CanvasLayer/LevelText.rect_global_position.x = -1920
	$CanvasLayer/ScoreText.rect_global_position.x = -1920
	$CanvasLayer/HiText.rect_global_position.x = -1920
	
	$CanvasLayer/TimeText.text = "Total time: " + str(Global.total_time)
	$CanvasLayer/LevelText.text = "Final level: " + str(Global.total_level)
	$CanvasLayer/ScoreText.text = "Total score: " + str(Global.total_score)
	$CanvasLayer/HiText.text = "new highscore! your place: " + str(new_highscore_place)

	$CanvasLayer/QuitButton.rect_global_position.x = -500
	
	$Tween.interpolate_property($CanvasLayer/TitleLabel,"rect_global_position:y",-500,110,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($CanvasLayer/CreatorLabel,"rect_global_position:y",-500,230,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,0.5)
	
	$Tween.interpolate_property($CanvasLayer/TimeText,"rect_global_position:x",-1920,0,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,1.5)
	$Tween.interpolate_property($CanvasLayer/LevelText,"rect_global_position:x",-1920,0,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,1.75)
	$Tween.interpolate_property($CanvasLayer/ScoreText,"rect_global_position:x",-1920,0,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,2)
	
	if (is_new_highscore):
		$Tween.interpolate_property($CanvasLayer/HiText,"rect_global_position:x",-1920,0,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,2.25)
	
	$Tween.interpolate_property($CanvasLayer/QuitButton,"rect_global_position:x",-500,895,1,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,2.5)
	
	$Tween.start()
	
	yield($Tween,"tween_all_completed")
	
	var theme = get_parent().get_node("MenuTheme")
	if theme.playing == false and Global.is_music_on:
		theme.play()
	
	is_animation_finished = true

func _input(event):
	if (event is InputEventMouseButton):
		if (event.is_pressed() && event.button_index == 1 && !is_animation_finished):
			$Tween.remove_all()
			
			$CanvasLayer/TitleLabel.rect_global_position.y = 110
			$CanvasLayer/CreatorLabel.rect_global_position.y = 230
	
			$CanvasLayer/TimeText.rect_global_position.x = 0
			$CanvasLayer/LevelText.rect_global_position.x = 0
			$CanvasLayer/ScoreText.rect_global_position.x = 0
			
			if (is_new_highscore):
				$CanvasLayer/HiText.rect_global_position.x = 0
			
			$CanvasLayer/QuitButton.rect_global_position.x = 895
			
			is_animation_finished = true
			
			var theme = get_parent().get_node("MenuTheme")
			if theme.playing == false and Global.is_music_on:
				theme.play()

func check_for_highscore():

	for x in range(1,11):
		if (Global.highscores[x]["score"] < Global.total_score):
			$Highscore.play()
			is_new_highscore = true
			new_highscore_place = x
			
			Global.highscores[11] = {}
			
			for y in range(10,x):
				Global.highscores[y+1] = Global.highscores[y]
				
			Global.highscores[x] = {"level":Global.total_level,"score":Global.total_score}
			Global.highscores.erase(11)
			break
	
	Global.save_data(Global.highscores)

func _on_QuitButton_pressed():
	if (!is_animation_finished):
		return
	
	Composer.gotoScene(Composer.scenes["mainmenu"])
