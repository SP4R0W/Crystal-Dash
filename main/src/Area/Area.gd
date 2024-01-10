extends Node

func _ready():
	randomize()

	Composer.gotoScene(Composer.scenes["mainmenu"],false,true)

	var file = File.new()

	if (!file.file_exists(Global.save_file)):
		Global.save_data(Global.highscores_default)
		Global.highscores = Global.highscores_default
	else:
		Global.load_data()
