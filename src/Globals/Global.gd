extends Node

# DEBUG FIELDS
onready var skip_menu: bool = false

# GAME OPTIONS
onready var is_music_on: bool = true

onready var is_sfx_on: bool = true

onready var can_quit: bool = true

onready var can_interact: bool = false

onready var highscores_default: Dictionary = {
	1:{"level":20,"score":300000},
	2:{"level":18,"score":250000},
	3:{"level":16,"score":200000},
	4:{"level":14,"score":150000},
	5:{"level":12,"score":125000},
	6:{"level":10,"score":100000},
	7:{"level":7,"score":50000},
	8:{"level":4,"score":25000},
	9:{"level":3,"score":15000},
	10:{"level":1,"score":5000}
}

onready var highscores: Dictionary = {}

onready var screen_size = get_viewport().size

onready var save_file = "user://saveData.save"

onready var total_level = 2
onready var total_score = 6000
onready var total_time = 0

func _ready():
	print(screen_size)

func load_data():
	var file = File.new()
	file.open(save_file,File.READ)
	highscores = file.get_var()
	file.close()
	
func save_data(data):
	var file = File.new()
	file.open(save_file,File.WRITE)
	file.store_var(data)
	file.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
