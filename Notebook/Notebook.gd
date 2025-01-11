extends Node2D

@onready var ink = $Paper/Ink
@onready var turns = [$Icon, $Icon2]
var cur_turn = 0

func _ready():
	turns[0].is_turn = true

func _on_icon_end_turn():
	cur_turn = (cur_turn + 1)  % len(turns)
	turns[cur_turn].is_turn = true
