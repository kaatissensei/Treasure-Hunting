extends Panel

var showing_questions = true

var QBOX_THEME = preload("res://dialog.tres")

signal show_new_question
signal set_current_question(new_num : int)

func _ready() -> void:
	pass # Replace with function body.

func _change_num_questions(new_num_q_boxes : int):
	var current_num_q_boxes : int = %Questions/QScroll/QAGrid.get_child_count()
	if new_num_q_boxes > current_num_q_boxes:
		for i in range(current_num_q_boxes + 1, new_num_q_boxes + 1):
			Main.add_question()
			%Questions/QScroll/QAGrid.add_child(create_question_box(i))
	else: #decrease number of questions
		for j in range (current_num_q_boxes, new_num_q_boxes, -1):
			Main.remove_question()
			%Questions/QScroll/QAGrid.get_child(j-1).queue_free()
	

func create_question_box(q_num : int) -> LineEdit:
	var q_box : LineEdit = LineEdit.new()
	q_box.placeholder_text = "%d." % q_num
	q_box.theme = QBOX_THEME
	q_box.name = "Question%d" % q_num
	q_box.custom_minimum_size = Vector2(0.0, 80.0)
	
	return q_box

func _open_settings_menu() -> void:
	%SettingsMenu.visible = true

func _close_settings_menu() -> void:
	%SettingsMenu.visible = false

func _restart() -> void:
	set_current_question.emit(1)
	%SettingsMenu.visible = false
	%FinishScreen.visible = false
	%Shine.visible = false
	%DigSpotContainer.setup()
	%QuestionText.visible = Main.questions[0] != ""
	Main.is_first_team = true
	for score_box in get_tree().get_nodes_in_group("Scores"):
		score_box.set_current_score(0)
		score_box.get_parent().get_node("WinnerHat").visible = false

func _show_questions() -> void:
	for i in range(Main.num_questions):
		%Questions/QScroll/QAGrid.get_child(i).text = Main.questions[i]
	%Questions.visible = true

func _cancel_question_updates() -> void:
	%Questions.visible = false

func _confirm_question_updates() -> void:
	save_qa_text()
	%Questions.visible = false
	emit_signal("show_new_question")

func save_qa_text():
	if(showing_questions):
		for i in range(Main.num_questions):

			var question_box_text = %Questions/QScroll/QAGrid.get_child(i).text
			Main.questions[i] = question_box_text
	else:
		for i in range(Main.num_questions):
			var question_box_text = %Questions/QScroll/QAGrid.get_child(i).text
			Main.answers[i] = question_box_text

func _toggle_questions_answers() -> void:
	save_qa_text()
	showing_questions = !showing_questions
	if showing_questions:
		%QABtn.text = "Answers" #Meaning will switch to answers
		for i in range(Main.num_questions):
			%Questions/QScroll/QAGrid.get_child(i).text = Main.questions[i]
	else:
		%QABtn.text = "Questions"
		for i in range(Main.num_questions):
			%Questions/QScroll/QAGrid.get_child(i).text = Main.answers[i]


func _toggle_bonus_point(toggled_off: bool) -> void:
	Main.give_bonus_point = !toggled_off
	if toggled_off:
		%BonusPtToggle.text = "Off"
	else:
		%BonusPtToggle.text = "On"
	
	print("Bonus point is %s" % Main.give_bonus_point)
