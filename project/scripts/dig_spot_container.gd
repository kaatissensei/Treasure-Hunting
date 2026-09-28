extends GridContainer

var trees : Array
var TREE_TEXTURE = preload("res://assets/textures/ACNH_palm_sm.png")
var ROCK1_TEXTURE = preload("res://assets/textures/ACNH_rock1.png")
var ROCK3_TEXTURE = preload("res://assets/textures/ACNH_rock3.png")
var ROCK4_TEXTURE = preload("res://assets/textures/ACNH_rock4.png")
var rock_textures

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rock_textures = {
		0: ROCK1_TEXTURE,
		1: ROCK3_TEXTURE,
		2: ROCK4_TEXTURE
	}
	setup()

func setup() -> void:
	%Kappn.texture_normal = load("res://assets/textures/Kappn_aerial_sm_back.png")
	%Kappn/NextDialog.visible = false
	reset_dig_spots()
	bury_treasure()
	set_rocks()
	set_trees()

func reset_dig_spots():
	Main.treasure_found = false
	for dig_spot in get_tree().get_nodes_in_group("DigSpot"):
		dig_spot.disabled = false
		dig_spot.button_pressed = false
		dig_spot.z_index = 0
	for treasure in get_tree().get_nodes_in_group("Treasure"):
		treasure.texture = null

func set_rocks(): #set rocks after treasure so there's only one value to check against
	reset_dig_spots()
	var new_rock_coord : Array[int]
	#move below to separate function?
	for rock in Main.num_rocks:
		new_rock_coord = get_new_free_coord()
		place_rock(new_rock_coord)
		print("Rock placed at %d,%d" % [new_rock_coord[0], new_rock_coord[1]])

func set_trees():
	var new_tree_coord : Array[int]
	if !trees.is_empty():
		for tree_node in trees:
			tree_node.stretch_mode = 5
			tree_node.texture_disabled = rock_textures[trees.size() % 3]
	for tree in Main.num_trees:
		new_tree_coord = get_new_free_coord()
		place_tree(new_tree_coord)
		print("Tree placed at %d,%d" % [new_tree_coord[0], new_tree_coord[1]])

func get_new_free_coord() -> Array[int]:
	var new_free_coord = Main.get_new_coord()
	if (new_free_coord != Main.treasure_coord):
		
		return (new_free_coord)
	else:
		print("Can't place anything at %d,%d" % [new_free_coord[0], new_free_coord[1]])
		return get_new_free_coord()

func place_rock(new_rock_coord : Array[int]):
	var dig_spot_pos : int = Main._coords_to_int(new_rock_coord)
	get_child(dig_spot_pos).disabled = true

func place_tree(new_tree_coord : Array[int]):
	var dig_spot_pos : int = Main._coords_to_int(new_tree_coord)
	var new_spot = get_child(dig_spot_pos)
	new_spot.disabled = true
	new_spot.texture_disabled = TREE_TEXTURE
	new_spot.stretch_mode = 3
	new_spot.z_index = 1
	trees.push_back(new_spot)

func bury_treasure():
	var new_treasure_coord : Array[int] = Main.get_new_coord()
	Main.treasure_coord = new_treasure_coord
	print("Burried at %s" % ",".join(new_treasure_coord))
	#check for 
