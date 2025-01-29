extends Node2D

@onready var ink = $Paper/Ink
@onready var turns = [$Icon, $Icon2]
var cur_turn = 0
signal change_turn
signal select_map_item

func _ready():
	turns[0].is_turn = true
	change_turn.emit(0)

func _on_icon_end_turn():
	cur_turn = (cur_turn + 1)  % len(turns)
	turns[cur_turn].is_turn = true
	change_turn.emit(cur_turn)


func _on_note_card_toggle_movement(toggle):
	turns[cur_turn].is_moving = toggle


func _on_paper_select_map_item(item):
	select_map_item.emit(item)
