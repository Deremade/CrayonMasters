class_name Character extends MapItem

#Movement
var cur_path : Array
var moves = 5
#Actions
var actions = 1
var selcted_ability : Ability
var is_moving : bool = false
#Turns
var is_turn : bool = false : set = set_turn
signal change_turn

#Character info
@export var char_name : String

func _ready():
	grid_pos = start_pos
	$RichTextLabel.text = char_name

func continue_path():
	if(moves > 0 && cur_path != []):
		grid_pos = cur_path[0]
		cur_path.remove_at(0)
		moves -= 1
	else:
		$Timer.stop()

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
	if(selcted_ability != null):
		selcted_ability.use_ability(t)

func _on_timer_timeout():
	continue_path()

func set_turn(turn):
	if(turn):
		moves = 5
		actions = 1
	else :
		if(cur_path != []):
			start_movement()
		is_moving = false
		player_deselects_ability()
	change_turn.emit(turn)
	is_turn = turn

func get_characters(reach = -1):
	return get_parent().viable_targets(grid_pos, reach)

func get_interactables(reach):
	return get_parent().interactiables(grid_pos, reach)

func player_selects_ability(a : Ability):
	selcted_ability = a
	for pt in get_characters(a.reach) :
		pt.player_targeted(true)

func player_deselects_ability():
	selcted_ability = null
	finish_ability(get_characters())

func use_ability(target : Character):
	if(actions > 0):
		print(self, " uses ", selcted_ability, " on ", target)
		actions -= 1
	else :
		print("NO ACTIONS AVAILABLE")

func finish_ability(targets):
	for t in targets:
		t.player_targeted(false)

func interact(item : Interactiable):
	item.interact(self)

func _to_string():
	return char_name
