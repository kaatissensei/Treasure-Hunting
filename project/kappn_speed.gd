extends TextureRect

var bob_speed = 10
var bob_height = 7

@onready var start_position: Vector2 =  position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	var time = Time.get_unix_time_from_system()
	
	#bob up and down
	var y_pos 	= ((1+sin(time * bob_speed)) / 2) * bob_height
	global_position.y =  start_position.y - y_pos
	
