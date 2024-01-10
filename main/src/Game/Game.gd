extends Node

const score_table: Dictionary = {3:100,4:250,5:500,6:1000,7:2500,8:5000}
const time_table: Dictionary = {3:0.25,4:0.5,5:1,6:1.5,7:2,8:3}

var panel

var gem_offset_x: int = 3
var gem_offset_y: int = 3

var gem_amount_x: int = 10
var gem_amount_y: int = 10

var gem_width: int = 101
var gem_height: int = 101

var gem_scene = preload("res://src/Game/Objects/Gem.tscn")
var popup = preload("res://src/Game/Objects/Popup.tscn")

var gem_dict: Dictionary = {}

var first_gem = null
var second_gem = null

var game_time: int = 0
var game_score: int = 0
var game_level: int = 1

var bad_moves: int = 0

var time_decreasement: int = 25

var next_level_score = (game_level * 5000) + ((game_level^2) * 500)

var game_seed

func _ready():
	var theme = get_parent().get_node("MenuTheme")
	theme.stop()

	panel = get_node("CanvasLayer/Field")
	game_seed = randi() % Seeds.seeds.size()

	fill_field_with_seed(game_seed)

	game_level = 1
	game_score = 0
	game_time = 0

	for x in range(10,-1,-1):
		if (game_score < Global.highscores[x]["score"]):
			$CanvasLayer/Panel/HiText.text = "Next highscore:\n" + str(Global.highscores[x]["score"])
			break

	$GameTimer.start()

func goto_game_over():
	Global.total_score = game_score
	Global.total_level = game_level
	Global.total_time = game_time
	Composer.gotoScene(Composer.scenes["endgame"],true,true)

func get_gem_at_pos(pos):
	for gem in gem_dict:
		if gem_dict[gem]["position"] == pos:
			return gem

	return null


func get_near_gems(main_gem):
	var main_pos = gem_dict[main_gem]["position"]

	# get gem on the right
	var gem1 = get_gem_at_pos(Vector2(main_pos.x + 1,main_pos.y))

	# get gem on the left
	var gem2 = get_gem_at_pos(Vector2(main_pos.x - 1,main_pos.y))

	# get the upward gem
	var gem3 = get_gem_at_pos(Vector2(main_pos.x,main_pos.y - 1))

	# get the downward gem
	var gem4 = get_gem_at_pos(Vector2(main_pos.x,main_pos.y + 1))

	return [gem1,gem2,gem3,gem4]


func check_if_gem_in_range(main_gem,find_gem) -> bool:
	if main_gem == find_gem:
		Global.can_interact = true
		Global.can_quit = true
		return false

	var gems = get_near_gems(main_gem)

	for gem in gems:
		if (gem != null):
			if (gem == find_gem):
				return true

	Global.can_interact = true
	Global.can_quit = true
	return false

func find_next_gem(direction,gem):
	match direction:
		Vector2(-1,0):
			var this_gem_pos = gem_dict[gem]["position"]
			var next_gem = get_gem_at_pos(Vector2(this_gem_pos.x + 1,this_gem_pos.y))
			if (next_gem != null):
				return next_gem

		Vector2(1,0):
			var this_gem_pos = gem_dict[gem]["position"]
			var next_gem = get_gem_at_pos(Vector2(this_gem_pos.x - 1,this_gem_pos.y))
			if (next_gem != null):
				return next_gem

		Vector2(0,-1):
			var this_gem_pos = gem_dict[gem]["position"]
			var next_gem = get_gem_at_pos(Vector2(this_gem_pos.x,this_gem_pos.y - 1))
			if (next_gem != null):
				return next_gem

		Vector2(0,1):
			var this_gem_pos = gem_dict[gem]["position"]
			var next_gem = get_gem_at_pos(Vector2(this_gem_pos.x,this_gem_pos.y + 1))
			if (next_gem != null):
				return next_gem

	return null

func check_if_gems_lined():
	$GameTimer.paused = true

	Global.can_quit = false
	Global.can_interact = false

	var gems_to_break = []
	var directions_to_search = [Vector2(1,0),Vector2(-1,0),Vector2(0,-1),Vector2(0,1)]

	var cur_gem_type
	var cur_neighbors_to_search = []

	var x_line = []
	var y_line = []

	for gem in gem_dict:
		x_line = []
		y_line = []

		x_line.append(gem_dict[gem]["position"])
		y_line.append(gem_dict[gem]["position"])
		cur_gem_type = gem.get_node("AnimatedSprite").animation

		# Check all 4 directions independently
		for direction in directions_to_search:
			cur_neighbors_to_search = []
			cur_neighbors_to_search.append(find_next_gem(direction,gem))

			for neighbor in cur_neighbors_to_search:
				# check if neighbor even exists
				if (neighbor != null):
					var cur_neighbor_type = neighbor.get_node("AnimatedSprite").animation

					# compare the types to see if they match
					if (cur_neighbor_type == cur_gem_type):
						# add the gem to the correct line (x or y)
						if (direction == Vector2(1,0) or direction == Vector2(-1,0)):
							x_line.append(gem_dict[neighbor]["position"])
						elif (direction == Vector2(0,1) or direction == Vector2(0,-1)):
							y_line.append(gem_dict[neighbor]["position"])

						cur_neighbors_to_search.append(find_next_gem(direction,neighbor))
					else:
						# stop searching if the next neighbor isn't matching
						break

					# get the next neighbor and repeat
				else:
					# if neighbor doesnt exist then line ends and continue with the next direction
					break

		# iterate through the lists and add lines to break if they haven't been added

		if (x_line.size() > 2):
			x_line.sort()
			if (not x_line in gems_to_break):
				gems_to_break.append(x_line)

		if (y_line.size() > 2):
			y_line.sort()
			if (not y_line in gems_to_break):
				gems_to_break.append(y_line)

	if (len(gems_to_break) < 1):
		return false

	remove_gems(gems_to_break)
	gems_to_break = []
	return true

	$GameTimer.paused = false

func add_score(value,pos):

	game_score += value

	$CanvasLayer/Panel/ScoreText.text = "Score: " + str(game_score)

	var new_popup = popup.instance()
	panel.add_child(new_popup)
	new_popup.rect_position = pos
	new_popup.show_text(str(value),96)

	for x in range(10,-1,-1):
		if (game_score < Global.highscores[x]["score"]):
			$CanvasLayer/Panel/HiText.text = "Next highscore:\n" + str(Global.highscores[x]["score"])
			break

	if (game_score >= next_level_score):
		if Global.is_sfx_on:
			$SFX/NextLevel.play()
		game_level += 1
		next_level_score = (game_level * 5000) + ((game_level^2) * 500) + int(game_score / 2)

		$CanvasLayer/Panel/LevelText.text = "Level: " + str(game_level)

func score_line(line):
	var pos = Vector2(0,0)

	if (line.size() % 2 == 0):
		var middle = floor(line.size() / 2)
		pos = Vector2((line[middle].x * gem_width) * 0.95,line[middle].y * gem_height)
	else:
		var middle = floor(line.size() / 2) - 1
		pos = Vector2(line[middle].x * gem_width,line[middle].y * gem_height)

	add_score(score_table[line.size()],pos)
	$CanvasLayer/ProgressBar.value += time_table[line.size()]

func fill_empty_spaces():
	$GameTimer.paused = true

	var gems_to_add = []
	var prev_item = "1"

	for gem in gem_dict:
		if (gem.modulate.a < 1):
			var sprite = str((randi() % 6) + 1)
			if (not sprite == prev_item):
				prev_item = sprite
				gems_to_add.append({"position":gem_dict[gem]["position"],"type":sprite})
				continue
			else:
				while (sprite == prev_item):
					sprite = str((randi() % 6) + 1)
					if (not sprite == prev_item):
						prev_item = sprite
						gems_to_add.append({"position":gem_dict[gem]["position"],"type":sprite})
						break

	var tween = get_tree().create_tween()

	for gem in gems_to_add:
		var this_gem = get_gem_at_pos(gem["position"])

		var animSprite = this_gem.get_node("AnimatedSprite")
		animSprite.animation = gem["type"]

		if (this_gem.modulate.a == 0):
			tween.tween_property(this_gem,"modulate:a",1.0,0.1)

		gem_dict[this_gem]["type"] = animSprite.animation

	tween.play()
	yield(tween,"finished")

	if (!check_if_gems_lined()):
		$GameTimer.paused = false
		Global.can_quit = true
		Global.can_interact = true

func move_empty_gems():
	$GameTimer.paused = true

	var needs_moving = false
	var empty_gem = false

	for x in range(0,8):
		empty_gem = false
		for y in range(7,-1,-1):
			var gem = get_gem_at_pos(Vector2(x,y))
			if (gem.modulate.a > 0.9):
				if (empty_gem):
					needs_moving = true
					break
			else:
				if (!empty_gem):
					empty_gem = true
					continue

		if (needs_moving):
			break

	if (needs_moving):
		for y in range(7,-1,-1):
			var skip_timer = true
			for x in range(7,-1,-1):
				var gem = get_gem_at_pos(Vector2(x,y))
				if (gem.modulate.a > 0.9):
					continue
				else:
					skip_timer = false
					var next_gem = find_next_gem(Vector2(0,-1),gem)
					if (next_gem != null):
						move_gems(gem,next_gem,0.01)

			if (!skip_timer):
				yield(get_tree().create_timer(0.01),"timeout")

		move_empty_gems()

	if (!needs_moving):
		fill_empty_spaces()

	$GameTimer.paused = false

func remove_gems(gem_list):
	$GameTimer.paused = true
	Global.can_quit = false
	Global.can_interact = false

	if (gem_list.size() > 1):
		add_score((gem_list.size() - 1) * 500,Vector2(panel.rect_size.x/2,panel.rect_size.y/2))

	if Global.is_sfx_on:
		match gem_list.size():
			1:
				$SFX/GemBreak.play()
			2:
				$SFX/Combo2.play()
			3:
				$SFX/Combo3.play()
			4:
				$SFX/Combo4.play()
			5:
				$SFX/Combo5.play()
			6:
				$SFX/Combo6.play()
			_:
				$SFX/Combo7.play()

	for gem_line in gem_list:
		var tween = get_tree().create_tween()
		score_line(gem_line)
		for gem_pos in gem_line:
			var gem = get_gem_at_pos(gem_pos)
			if (gem.modulate.a == 1):
				tween.tween_property(gem,"modulate:a",0.0,0.1)

		tween.play()
		yield(tween,"finished")

	yield(get_tree().create_timer(0.1),"timeout")

	move_empty_gems()

	$GameTimer.paused = false

func move_gems(gem1,gem2,speed=0.1,quiet=true):
	$GameTimer.paused = true

	Global.can_quit = false
	Global.can_interact = false

	var pos1 = gem_dict[gem1]["position"]
	var pos2 = gem_dict[gem2]["position"]

	var pos1_to_move = Vector2(pos2.x * gem_width + gem_offset_x,pos2.y * gem_height + gem_offset_y)
	var pos2_to_move = Vector2(pos1.x * gem_width + gem_offset_x,pos1.y * gem_height + gem_offset_y)

	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()

	tween.tween_property(gem1,"position",pos1_to_move,speed)
	tween2.tween_property(gem2,"position",pos2_to_move,speed)

	tween.play()
	tween2.play()

	if !quiet and Global.is_sfx_on:
		$SFX/Move.play()

	yield(tween,"finished")
	yield(tween2,"finished")

	gem_dict[gem1]["position"] = pos2
	gem_dict[gem2]["position"] = pos1

	$GameTimer.paused = false

func gem_clicked(gem):
	Global.can_quit = false
	Global.can_interact = false

	if (first_gem == null):
		first_gem = gem
		var sprite = first_gem.get_node("Border")
		sprite.visible = true

		Global.can_quit = true
		Global.can_interact = true

	elif (second_gem == null):
		if check_if_gem_in_range(first_gem,gem):
			second_gem = gem

			var sprite = first_gem.get_node("Border")
			sprite.visible = false

			move_gems(first_gem,second_gem,0.1,false)

			yield(get_tree().create_timer(0.15),"timeout")

			if (check_if_gems_lined() == false):
				if Global.is_sfx_on:
					$SFX/BadMove.play()
				move_gems(second_gem,first_gem)

				yield(get_tree().create_timer(0.1),"timeout")

				bad_moves += 1
				if (bad_moves == 5):
					bad_moves = 0
					remove_board(true)
				else:
					Global.can_quit = true
					Global.can_interact = true
			else:
				bad_moves = 0

			first_gem = null
			second_gem = null
		else:
			var sprite = first_gem.get_node("Border")
			sprite.visible = false
			first_gem = null

func remove_board(restore,gameover=false):
	Global.can_quit = false
	Global.can_interact = false

	if Global.is_sfx_on:
		$SFX/GameOver.play()

	yield(get_tree().create_timer(2),"timeout")

	# Get a random seed
	var board_seed = Seeds.seeds[randi() % Seeds.seeds.size()]

	for i in range(gem_amount_x):
		for j in range(gem_amount_y):
			var gem = get_gem_at_pos(Vector2(i,j))

			var tween = gem.get_node("Tween")
			tween.interpolate_property(gem,"modulate:a",1,0,0.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
			tween.interpolate_property(gem,"scale",Vector2(1,1),Vector2(0,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.start()

			yield(get_tree().create_timer(0.01),"timeout")

	if gameover:
		$Player.can_interact = false
		$Player.stop_playing()
		yield(get_tree().create_timer(2),"timeout")
		goto_game_over()

	# Redraw all the gems again
	if restore:
		for i in range(gem_amount_x):
			for j in range(gem_amount_y):
				var gem = get_gem_at_pos(Vector2(i,j))

				var animSprite = gem.get_node("AnimatedSprite")
				animSprite.animation = board_seed[i][j]

				gem_dict[gem]["type"] = animSprite.animation

				var tween = gem.get_node("Tween")
				tween.interpolate_property(gem,"modulate:a",0,1,0.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
				tween.interpolate_property(gem,"scale",Vector2(0,0),Vector2(1,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
				tween.start()

				yield(get_tree().create_timer(0.01),"timeout")

	Global.can_quit = true
	Global.can_interact = true

func fill_field_with_seed(seed_idx):
	# Only call this on start of new game
	# This function will fill the board with gems and it expects an empty board.

	Global.can_quit = false
	Global.can_interact = false

	var board_seed = Seeds.seeds[seed_idx]

	var gem_x = gem_offset_x
	var gem_y = gem_offset_y

	# Code responsible for drawing gems
	for i in range(gem_amount_x):
		gem_x = gem_offset_x
		for j in range(gem_amount_y):
			var gem = gem_scene.instance()
			panel.add_child(gem)

			gem.position = Vector2(gem_x,gem_y)
			gem.connect("gem_clicked",self,"gem_clicked")
			gem.modulate.a = 0
			gem.scale = Vector2(0,0)

			var animSprite = gem.get_node("AnimatedSprite")
			animSprite.animation = board_seed[i][j]

			gem_dict[gem] = {"position":Vector2(j,i),"type":animSprite.animation}

			var tween = gem.get_node("Tween")
			tween.interpolate_property(gem,"modulate:a",0,1,0.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
			tween.interpolate_property(gem,"scale",Vector2(0,0),Vector2(1,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.start()

			yield(get_tree().create_timer(0.01),"timeout")

			gem_x += gem_width

		gem_y += gem_height

	$Player.play_random()
	$Player.can_interact = true

	Global.can_quit = true
	Global.can_interact = true

func _on_TimeTimer_timeout():
	game_time += 1

	if (game_time >= 300):
		$GameTimer.wait_time = 0.5
	elif (game_time >= 150):
		$GameTimer.wait_time = 1
	elif (game_time >= 60):
		$GameTimer.wait_time = 1.5
	elif (game_time < 60):
		$GameTimer.wait_time = 2

	$CanvasLayer/Panel/TimeText.text = "Time: " + str(game_time)


func _on_QuitButton_pressed():
	$Player.can_interact = false
	$Player.stop_playing()

	if Global.can_quit:
		$GameTimer.stop()
		Composer.gotoScene(Composer.scenes["mainmenu"])


func _on_GameTimer_timeout():
	$CanvasLayer/ProgressBar.value -= 1
	if ($CanvasLayer/ProgressBar.value < 10) and Global.is_sfx_on:
		$SFX/Tick.play()

	if ($CanvasLayer/ProgressBar.value < 0):
		Global.can_interact = false
		Global.can_quit = false
		$TimeTimer.stop()
		$GameTimer.stop()
		remove_board(false,true)
