extends Node

#Grid settings
var num_cols : int
var num_rows : int
var has_rocks : bool = false
var num_rocks : int = 2
var num_trees : int = 3
var num_teams : int = 10

var treasure_found : bool = false
var treasure_coord : Array[int] = [0,0]
var last_treasure_coord : Array[int] = [0,0]

var points_to_add : int
var give_bonus_point : bool = true
var is_first_team : bool = true

var num_questions : int = 15
var questions : Array[String]
var answers : Array[String]
var current_question : int = 1

var hex_Gray : String = "#737373" #was Color.DIM_GRAY
var hex_Red : String = "#E60000"
var hex_Blue : String = "#0000ff"
var hex_Yellow : String = "#ffff00"
var hex_Green : String = "#00af00"
var hex_Purple : String = "#a200ff"
var hex_Orange : String = "#ff8400" #was ff8a00
var hex_LBlue : String = "#00fff0"
var hex_Pink : String = "#ff00c6" #was fa6eff
var hex_LGreen : String = "#80ff00"
var hex_Black : String = "#0a0a0a"

var COLORS : Array[Color]= [Color.html(hex_Gray), Color.html(hex_Red), Color.html(hex_Blue), 
Color.html(hex_Yellow), Color.html(hex_Green), Color.html(hex_Purple), Color.html(hex_Orange), 
Color.html(hex_LBlue), Color.html(hex_Pink), Color.html(hex_LGreen), Color.html(hex_Black)]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	num_cols = 7
	num_rows = 5
	reset_question_array()

func reset_question_array():
	questions.clear()
	answers.clear()
	questions.resize(num_questions)
	answers.resize(num_questions)

func add_question():
	num_questions += 1
	questions.push_back("")
	answers.push_back("")

func remove_question():
	num_questions -= 1
	questions.pop_back()
	answers.pop_back()
	

func _get_coords(dig_spot_int : int) -> Array[int]:
	#[r,c]
	var row = floori((dig_spot_int-1)/(num_cols))
	var col = (dig_spot_int-1) % (num_cols) #-1 to account for 0th
	
	return [row, col]

func _coords_to_int(coords : Array[int]) -> int:
	var row : int = coords[0]
	var col : int = coords[1]
	var position : int = (row * num_cols) + col
	
	return position

func get_new_coord() -> Array[int]:
	var new_row = randi() % num_rows
	var new_col = randi() % num_cols
	
	#Check if different from last time
	#Use ||randi()any other square is ok
	#Maybe add && option so it has to be a new row and col, making it farther away
	if(new_row != last_treasure_coord[0] || new_col != last_treasure_coord[1]): #Makes treasure move around a little more
		return [new_row, new_col]
	else:
		return get_new_coord()

func set_treasure_coord(new_treasure_coord : Array[int]):
	treasure_coord = new_treasure_coord

func check_for_treasure(dig_coords: Array) -> int:
	var dig_r = dig_coords[0]
	var dig_c = dig_coords[1]
	if(dig_coords == treasure_coord):
		print("You found the treasure!")
		return 5
	else:
		return get_gold(dig_r, dig_c)

func get_gold(dig_row: int, dig_col: int) -> int:
	var row_dist = dig_row - treasure_coord[0]
	var col_dist = dig_col - treasure_coord[1]
	
	if(abs(row_dist) <= 1 && abs(col_dist) <= 1):
			return 3
	elif(abs(row_dist) <= 2 && abs(col_dist) <= 2):
			return 1
	else:
			return 0
		
func get_team_color(team_num : int):
	return COLORS[team_num]

func clear_questions():
	questions.clear()

	
	
	
