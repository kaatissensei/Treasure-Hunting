extends RichTextLabel

var team_num = 0
var current_score = 0
var btn_pts_up
var btn_pts_dwn

var btns_visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	team_num = int(name)

	#Connect up/down buttons
	btn_pts_up = $ChangePts/PtsUp
	btn_pts_dwn = $ChangePts/PtsDown
	btn_pts_up.pressed.connect(_add_points.bind(1))
	btn_pts_dwn.pressed.connect(_subtract_points.bind(1))
	focus_entered.connect(_add_points)
	#focus_exited.connect(_hide_buttons)
	%EditBtn.pressed.connect(toggle_buttons)
	
	
	var new_stylebox = btn_pts_up.get_theme_stylebox("normal").duplicate()
	new_stylebox.bg_color = Main.get_team_color(team_num)
	btn_pts_up.add_theme_stylebox_override("normal", new_stylebox)
	btn_pts_up.add_theme_stylebox_override("hover", new_stylebox)
	btn_pts_up.add_theme_stylebox_override("pressed", new_stylebox)
	btn_pts_dwn.add_theme_stylebox_override("normal", new_stylebox)
	btn_pts_dwn.add_theme_stylebox_override("hover", new_stylebox)
	btn_pts_dwn.add_theme_stylebox_override("pressed", new_stylebox)

func _add_points(pts_to_add : int = Main.points_to_add):
	current_score += pts_to_add
	text = str(current_score)

func _subtract_points(pts_to_sub : int): #For now, only used with -1 button
	if current_score > 0:
		current_score -= pts_to_sub
	text = str(current_score)

func set_current_score(new_score : int):
	current_score = new_score
	text = str(current_score)

func _show_buttons():
	btn_pts_up.visible = true
	btn_pts_dwn.visible = true

func _hide_buttons():
	btn_pts_up.visible = false
	btn_pts_dwn.visible = false

func toggle_buttons():
	btns_visible = !btns_visible
	btn_pts_up.visible = btns_visible
	btn_pts_dwn.visible = btns_visible
