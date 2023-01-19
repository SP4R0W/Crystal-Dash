extends Node


func _ready():
	randomize()
	if (Global.skip_menu):
		Composer.gotoScene(Composer.scenes["game"],false,true)
	else:
		Composer.gotoScene(Composer.scenes["mainmenu"],false,true)
		
	var file = File.new()
	print(file.file_exists(Global.save_file))
	if (!file.file_exists(Global.save_file)):
		Global.save_data(Global.highscores_default)
		Global.highscores = Global.highscores_default
	else:
		Global.load_data()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
