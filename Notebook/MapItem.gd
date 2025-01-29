class_name MapItem extends Sprite2D

var grid_pos : Vector2i : set = set_grid_pos
var cur_path : Array
var moves = 50
var is_turn : bool = false : set = set_turn
var is_moving : bool = false
signal end_turn
@export var char_name : String
@export var start_pos : Vector2i

func _ready():
	grid_pos = start_pos

func continue_path():
	if(moves > 0 && cur_path != []):
		grid_pos = cur_path[0]
		cur_path.remove_at(0)
		moves -= 1
	else:
		$Timer.stop()
		is_turn = false

func start_movement():
	$Timer.start()

func set_grid_pos(new_pos):
	grid_pos = new_pos
	position = (grid_pos*64)+Vector2i(32,32)

func calc_tile_cost(tile : Tile):
	return tile.cost

func _on_paper_select_tile(t):
	if(is_moving):
		cur_path = get_parent().get_node("Paper").map_path(self, t)
		start_movement()

func _on_timer_timeout():
	continue_path()

func set_turn(turn):
	print(char_name, "'s turn")
	if(turn):
		moves = 5
		if(cur_path != []):
			start_movement()
	else :
		is_moving = false
		end_turn.emit()
	is_turn = turn
