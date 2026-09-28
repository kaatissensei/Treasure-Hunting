extends Control


@onready var upload_button: Button = %"LoadCSVBtn" as Button
#@onready var main_upload_btn: Button = %"UploadCSV" as Button
var csvFile
var csvArray = []

func _ready() -> void:
	## file_access_web functions won't work if you don't connect them!
	upload_button.pressed.connect(_on_upload_pressed)
	#main_upload_btn.pressed.connect(_on_upload_pressed)
	#file_access_web.load_started.connect(_on_file_load_started)
	file_access_web.loaded.connect(_on_file_loaded)
	#file_access_web.progress.connect(_on_progress)
	file_access_web.error.connect(_on_error)


func load_question_menu():
	print(str(Main.questions.size()))
	for i in range(Main.questions.size()):
		%Questions/ScrollContainer/QAGrid.get_child(i).text = Main.questions[i]
		print(%Questions/ScrollContainer/QAGrid.get_child(i).name)
		#if Main.answers[i] != 0:
		#%Questions/QAGrid.get_child(i).text = Main.answers[i]

func _open_menu():
	load_question_menu()
	visible = true

func _close_menu():
	visible = false

func _open_settings():
	%SettingsMenu.visible = true

func _close_settings():
	%SettingsMenu.visible = false

#WEB FILE ACCESS FUNCTIONS ------------------------------------------------\

var file_access_web: FileAccessWeb = FileAccessWeb.new()

#func _on_file_load_started(file_name: String) -> void:
	#progress.visible = true
	#success_label.visible = false

func _on_error() -> void:
	push_error("Error!")

func _on_upload_pressed() -> void:
	if OS.has_feature("web"):
		file_access_web.open(".csv")
	else:
		pass
		#var path = "res://"
		#var filename = "PercentBalloonTest.csv"
		#var file := FileAccess.open(path.path_join(filename), FileAccess.READ)
		#if file == null:
			#var error_str: String = error_string(FileAccess.get_open_error())
			#push_warning("Couldn't open file because: %s" % error_str)
		#print(file)
		#Main.csvFile = file
		#Main.parse_csv()
		#load_question_menu()
		#%DEBUG.text = Main.csvArray

#func _on_progress(current_bytes: int, total_bytes: int) -> void:
#	pass
	#var percentage: float = float(current_bytes) / float(total_bytes) * 100
	#progress.value = percentage

func _on_file_loaded(_file_name: String, _type: String, base64_data: String) -> void:
	var utf8_data: String = Marshalls.base64_to_utf8(base64_data)
	#var string_data: String = base64_data.get_string_from_utf8()
	#Hide Main Menu
	%MainMenu.visible = false
	%UI.visible = true
	#if %MainMenu.visible:
		#%ChooseNumPlayers.visible = true
	#if %LoadMenu.visible:
		#%LoadMenu.visible = false
	
	var file = FileAccess.open("user://TH_Questions.csv", FileAccess.WRITE)
	if FileAccess.file_exists("user://TH_Questions.csv"):
		file.store_string(utf8_data)
		file.close() #Don't forget this!
		csvFile = FileAccess.open("user://TH_Questions.csv", FileAccess.READ)
		parse_csv()
		load_question_menu()
		
		%QuestionText.text = "Q1: " + Main.questions[0]
		#%DEBUG.text = Main.csvArray
	else:
		%DEBUG.text = "Can't find file."

func parse_csv():
	var csv_line_len = 2 #number of elements per csv line
	#clear_questions()
	#csvArray.clear()
	while csvFile.get_position() < csvFile.get_length():
		var csvLine = csvFile.get_csv_line()
		csvArray.push_back(csvLine)
	csvArray.pop_front() #removes title

	Main.questions.clear()
	Main.answers.clear()
	for i in range(csvArray.size()):
		var arr = csvArray.slice(i,i+csv_line_len)[0]
		#Assign variables here
		Main.questions.push_back(arr[0])
		Main.answers.push_back(arr[1])

func _open_load_menu() -> void:
	%LoadMenu.visible = true
