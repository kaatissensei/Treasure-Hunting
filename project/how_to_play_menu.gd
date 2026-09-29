extends TextureRect

var h2p_current_page : int = 1

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _open_how_to_play() -> void:
	%MainMenu.visible = false
	%HowToPlayMenu.visible = true
	%AudioPlayer.get_stream_playback().play_stream(preload("res://assets/sounds/UI_Decide.wav"), 0, 0, randf_range(0.9, 1.1))

func _h2p_next() -> void:
	if h2p_current_page == 1:
		%HTPPrevPage.visible = true
	match h2p_current_page:
		1:
			%HowToPlayMenu.get_child(h2p_current_page - 1).visible = false
			%HowToPlayMenu.get_child(h2p_current_page).visible = true
		2:
			%HTPPoints.visible = true
		_:
			h2p_current_page = 0
			for page in get_tree().get_nodes_in_group("HowToPlay"):
				page.visible = true
			%HTPPoints.visible = false
			%HowToPlayMenu.visible = false
			emit_signal("start_game")
	h2p_current_page += 1


func _h2p_prev() -> void:
	if h2p_current_page == 2:
		%HTPPrevPage.visible = false
	
	match h2p_current_page:
		3:
			%HTPPoints.visible = false
		2:
			%HowToPlayMenu.get_child(h2p_current_page - 2).visible = true
			%HowToPlayMenu.get_child(h2p_current_page - 1).visible = false
			%HTPPrevPage.visible = false
		_:
			%HowToPlayMenu.visible = false
			%MainMenu.visible = true
	
	if h2p_current_page > 1:
		h2p_current_page -= 1
