extends Node

var current_scene = null

var is_entering_scene: bool = false

onready var screen: Dictionary = {
	"width" : get_viewport().size.x,
	"height": get_viewport().size.y,
	"center": Vector2()
}

onready var scenes: Dictionary = {}

func _ready():
	scenes = {
	"mainmenu":"res://src/Menu/MainMenu.tscn",
	"highscores":"res://src/Menu/Highscores.tscn",
	"options":"res://src/Menu/Options.tscn",
	"help":"res://src/Menu/Help.tscn",
	"endgame":"res://src/Menu/Endgame.tscn",
	"game":"res://src/Game/Game.tscn"}

func gotoScene(newScene,animate=true,quiet=false):
	if (!is_entering_scene):
		if !quiet and Global.is_sfx_on:
			$Click.play()
		is_entering_scene = true
		call_deferred("defferedGotoScene",newScene,animate)

func defferedGotoScene(newScene,animate=true):
	var root = get_tree().root.get_node("Area")
	
	if (animate):
		var rootControl = CanvasLayer.new()
		var colorRect = ColorRect.new()
		var tween = Tween.new()
		
		colorRect.set_frame_color(Color(0, 0, 0, 0))
		
		get_tree().get_root().add_child(rootControl)
		rootControl.add_child(colorRect)
		rootControl.add_child(tween)
		colorRect._set_size(Vector2(screen.width, screen.height))
		
		tween.interpolate_property(colorRect, "color", Color(0, 0, 0, 0), Color.black, .5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		var scene = root.get_node(current_scene.name)
		scene.queue_free()
			
		var next_level = load(newScene)
		root.add_child(next_level.instance())
		
		tween.interpolate_property(colorRect, "color", colorRect.get_frame_color(), Color(0, 0, 0, 0), .5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		rootControl.queue_free()
		
		current_scene = root.get_child(root.get_child_count() - 1)
		
	else:
		if (current_scene != null):
			var scene = root.get_node(current_scene.name)
			scene.queue_free()
			
			var next_level = load(newScene)
			root.add_child(next_level.instance())
			
			current_scene = root.get_child(root.get_child_count() - 1)
			
		else:
			var next_level = load(newScene)
			root.add_child(next_level.instance())
			
			current_scene = root.get_child(root.get_child_count() - 1)
		
	is_entering_scene = false
