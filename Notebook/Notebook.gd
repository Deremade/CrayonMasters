extends Node2D

@onready var ink = $Paper/Ink
@onready var turns = [$Icon, $Icon2]
@onready var interactables = [$Sprite2D]
var cur_turn = 0
signal change_turn
signal select_map_item

func _ready():
	turns[0].is_turn = true
	change_turn.emit(0)

func _on_icon_change_turn(is_turn):
	if is_turn:
		return
	cur_turn = (cur_turn + 1)  % len(turns)
	turns[cur_turn].is_turn = true
	change_turn.emit(cur_turn)

func _on_paper_select_map_item(item):
	select_map_item.emit(item)

func viable_targets(start, reach = -1):
	var viable = []
	if(reach == -1):
		return turns
	for character in turns:
		if($Paper.can_target(start, character.grid_pos, reach)):
			viable.append(character)
	return viable

func interactiables(start, reach):
	var viable = []
	for i in interactables:
		if($Paper.can_target(start, i.grid_pos, reach)):
			viable.append(i)
	return viable
