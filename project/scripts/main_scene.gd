extends Node2D

const BELLS = preload("res://assets/textures/ACNH_bells.png")
const TRIP_BELLS = preload("res://assets/textures/ACNH_triple_bells.png")
const CHEST = preload("res://assets/textures/ACNH_treasure_chest.png")
const GARBAGE = preload("res://assets/textures/ACNH_tin_can.png")
const KAPPNFACE = preload("res://assets/textures/Kappn_aerial_sm.png")

const DIG_WAV = preload("res://assets/sounds/Pl_DigIn_Sand_00.wav")
const STONE_WAV = preload("res://assets/sounds/Pl_DigInvalid_Stone_00.wav")
const BELL_WAV = preload("res://assets/sounds/Obj_FallLand_Coin_00.wav")
const TRIP_WAV = preload("res://assets/sounds/Obj_FallLand_CoinBag_00.wav")
const CHEST_WAV = preload("res://assets/sounds/Pl_DisplayItem.wav")
var playback

var shine : Control
var kappn_start_pos : Vector2
var main_showing_question : bool = true

var scores : Array[int]
var team_map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shine = %Shine
	kappn_start_pos = %Kappn.position
	%AudioPlayer.play()
	playback = %AudioPlayer.get_stream_playback()
	%HowToPlayMenu.start_game.connect(_start_game)
	%SettingsMenu.show_new_question.connect(show_new_question)
	var team5Icon : Control
	if Main.num_teams > 8:
		team5Icon = %TeamIcon5L
	else:
		team5Icon = %TeamIcon5R
	
	team_map = {
		1: %TeamIcon1,
		2: %TeamIcon2,
		3: %TeamIcon3,
		4: %TeamIcon4,
		5: team5Icon,
		6: %TeamIcon6,
		7: %TeamIcon7,
		8: %TeamIcon8,
		9: %TeamIcon9,
		10: %TeamIcon10
	}
	
	_update_num_teams()
	


func _update_num_teams(new_num_teams : int = 8):
	Main.num_teams = new_num_teams
	
	#Control whether 5-purple is on left or right
	if new_num_teams > 5 && new_num_teams < 9:
		%TeamIcon5R.visible = true
		%TeamIcon5L.visible = false
		team_map[5] = %TeamIcon5R
	else:
		%TeamIcon5R.visible = false
		%TeamIcon5L.visible = true
		team_map[5] = %TeamIcon5L
	
	#Move 4-green to right if 6 teams
	if new_num_teams == 6:
		%TeamIcon4R.visible = true
		%TeamIcon4.visible = false
		team_map[4] = %TeamIcon4R
	else:		
		%TeamIcon4R.visible = false
		%TeamIcon4.visible = true
		team_map[4] = %TeamIcon4
	
	#Hide icons higher than current num_teams
	if new_num_teams > 4:
		for i in range(5,new_num_teams+1):
			team_map[i].visible = true
	if new_num_teams < 10:
		for j in range (new_num_teams + 1, 11):
			team_map[j].visible = false
		
		


func _dig(btn: TextureButton):
	#var btn_position : Vector2 = btn.position
	var dig_spot_int = int(btn.name)
	var dig_coords = Main._get_coords(dig_spot_int)
	#playback.play_stream(DIG_WAV, 0, 0, randf_range(0.9, 1.1))
	print("Digging at %s" % ",".join(dig_coords))
	Main.points_to_add = Main.check_for_treasure(dig_coords)
	show_treasure(Main.points_to_add, btn)

func show_treasure(pts: int, btn: TextureButton):
	var treasure_sprite
	var sound
	match pts:
		5: 
			treasure_sprite = CHEST
			sound = CHEST_WAV
			Main.treasure_found = true
			shine.reparent(btn, false)
			shine.visible = true
			%Kappn.texture_normal = KAPPNFACE
			%Kappn/NextDialog.visible = true
		3:
			treasure_sprite = TRIP_BELLS
			sound = TRIP_WAV
		1:
			treasure_sprite = BELLS
			sound = BELL_WAV
		_:
			treasure_sprite = GARBAGE
			sound = DIG_WAV
	btn.get_child(0).texture = treasure_sprite
	playback.play_stream(sound, 0, 0, randf_range(0.9, 1.1))


func _start_game() -> void:
	%MainMenu.visible = false
	%UI.visible = true
	playback.play_stream(preload("res://assets/sounds/UI_Decide_Title.wav"), 0, 0, randf_range(0.9, 1.1))
	%QuestionText.visible = Main.questions.size() > 0

func show_new_question() -> void:
	var current_q = Main.questions[Main.current_question - 1]
	if (current_q != ""):
		%QuestionText.text = "%d. %s" % [Main.current_question, current_q]
	else:
		%QuestionText.visible = false

func _next_sentence() -> void:
	if Main.treasure_found:
		#Move Kappn to the right
		move_kappn()
		await get_tree().create_timer(0.4).timeout
		#Speed wipe over screen
		speed_wipe()
		#Reset island for next sentence
		%DigSpotContainer.setup()
		shine.visible = false
		if (Main.current_question < Main.num_questions):
			Main.current_question += 1
			show_new_question()
		#Load next sentence
		

func move_kappn() -> void:
	var tween = create_tween()
	playback.play_stream(preload("res://assets/sounds/Obj_Boat_Land_01.wav"), 0, 0, randf_range(0.9, 1.1))
	tween.set_parallel()
	tween.tween_property(%Kappn, "rotation_degrees", -7.0, 0.1)
	tween.tween_property(%Kappn, "position:x", 1800, 0.4)
	tween.tween_property(%AudioPlayer, "volume_db", 0, 2.4)
	#tween.tween_property(%Kappn, "position:x", 1350, 0.05)
	await get_tree().create_timer(0.4).timeout
	tween.kill()
	%Kappn.rotation_degrees = 0.0
	%Kappn.set_position(kappn_start_pos)


func speed_wipe() -> void:
	playback.play_stream(preload("res://assets/sounds/boat_run_short.wav"), 0, 0, randf_range(0.9, 1.1))
	%Speed.visible = true
	var tween = create_tween()
	#tween.parallel()
	tween.tween_property(%KappnSpeed, "position:x", 2000.0, 2) #2k
	
	await get_tree().create_timer(2).timeout #2
	%KappnSpeed.position.x = -400.0
	%Speed.visible = false
	Main.points_to_add = 0
	playback.play_stream(preload("res://assets/sounds/Obj_Boat_Land_01.wav"), 0, 0, 1)
	
	#fade_tween.interpolate_property(playback, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	#fade_tween.start()

func _toggle_treasure_grid(toggled_on: bool) -> void:
	%TreasureGridPopup.visible = toggled_on

#Changes main QuestionText dialog to show the answer or question
func _switch_question_answer() -> void:
	main_showing_question = !main_showing_question
	if (main_showing_question):
		%QuestionText.text = Main.questions[Main.current_question-1]
	else:
		%QuestionText.text = Main.answers[Main.current_question-1]


func _close_settings() -> void:
	pass # Replace with function body.
