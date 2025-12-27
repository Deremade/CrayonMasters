extends Control

var selected_actor : CharacterDrawing
var selected_action : Ability

@onready var cur_turn = get_children()[0]:
	set(next_turn):
		cur_turn.change_turn(false)
		cur_turn = next_turn
		cur_turn.change_turn(true)
		if(cur_turn.actions == 0):
			go_next_turn()

func _ready():
	cur_turn.change_turn(true)

signal player_targeting(is_targeting: bool)

func _on_char_target(charactr : Character):
	if(selected_actor != cur_turn):
		Game.err_sticker("Not their turn!", self)
		return
	if selected_action:
		selected_actor.use_ability(selected_action, charactr)
	if(selected_actor.actions == 0):
		go_next_turn()


func _on_character_using_ability(toggled, ability, charactr):
	player_targeting.emit(toggled)
	if toggled:
		selected_action = ability
		selected_actor = charactr
	else:
		selected_action = null
		selected_actor = null 

func go_next_turn():
	var children = get_children()
	var next_num = children.find(cur_turn)+1
	next_num = next_num % len(children)
	cur_turn = children[next_num]
