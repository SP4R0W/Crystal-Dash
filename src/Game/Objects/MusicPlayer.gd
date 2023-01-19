extends Node

var current_track = 0

var prev_track = 0

var can_interact = false
var is_looped = false
var is_stopped = false

var prompt_texts = {true:"ON",false:"OFF"}

onready var tracks = []

func _ready():
	is_stopped = false
	
	tracks = [
		get_node("Track1"),
		get_node("Track2"),
		get_node("Track3"),
		get_node("Track4"),
		get_node("Track5"),
		get_node("Track6"),
		get_node("Track7"),
		get_node("Track8")
	]

func play_random():
	while (current_track == prev_track):
		current_track = (randi() % tracks.size()) - 1
		if (current_track != prev_track):
			prev_track = current_track
			break
	
	if (Global.is_music_on and !is_stopped):
		tracks[current_track].play()
	
func stop_playing():
	is_stopped = true
	tracks[current_track].stop()
	
func resume_playing():
	is_stopped = false
	if (Global.is_music_on):
		tracks[current_track].play()
	
func play_next_track():
	if (!is_stopped and can_interact):
		stop_playing()
		
		current_track += 1
		if (current_track > 7):
			current_track = 0
			
		prev_track = current_track
		
		get_tree().create_timer(0.1).connect("timeout",self,"resume_playing")
	
func play_prev_track():
	if (!is_stopped and can_interact):
		stop_playing()
		
		current_track -= 1
		if (current_track < 0):
			current_track = 7
			
		prev_track = current_track
		
		get_tree().create_timer(0.1).connect("timeout",self,"resume_playing")

func _on_Track_finished():
	if (!is_stopped):
		print("is_looped: ",is_looped)
		if (!is_looped):
			play_random()
		else:
			if Global.is_music_on:
				tracks[current_track].play()
		
func _input(event):
	if event.is_action_pressed("mute"):
		if (is_stopped):
			resume_playing()
		else:
			stop_playing()
		
	if event.is_action_pressed("loop"):
		is_looped = !is_looped
		get_parent().get_node("CanvasLayer/Panel/LoopText").text = "Loop music: " + prompt_texts[is_looped] 
		
	if event.is_action_pressed("next_track"):
		play_next_track()
		
	elif event.is_action_pressed("prev_track"):
		play_prev_track()
