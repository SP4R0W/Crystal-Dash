extends CanvasLayer

var background

var velocity = -100

func _ready():
	background = get_node("ParallaxBackground")

func _process(delta):
	background.scroll_offset.x += velocity * delta
