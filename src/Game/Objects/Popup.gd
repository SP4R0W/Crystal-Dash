extends Label

var tween

func _ready():
	modulate.a = 0
	
func show_text(text_to_show,size):
	tween = get_node("Tween")
	text = text_to_show
	get_font('font').size = size
	
	modulate.a = 1
	tween.interpolate_property(self,"modulate:a",1,0,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.interpolate_property(self,"rect_position:y",rect_position.y,rect_position.y - 100,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	
	get_tree().create_timer(1.1).connect("timeout",self,"kill")
	
func kill():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
