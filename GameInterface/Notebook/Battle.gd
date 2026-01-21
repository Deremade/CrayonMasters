extends Control

var selected_actor : CharacterDrawing
var selected_action : Ability
var charDrawing = preload("res://CharInterface/CharacterDrawing.tscn")
var cur_event : Event
var team1 = []
var team2 = []
var cur_turn:
	set(next_turn):
		if(cur_turn):
			cur_turn.change_turn(false)
		cur_turn = next_turn
		cur_turn.change_turn(true)
		if(cur_turn.actions == 0):
			go_next_turn()
		

func _ready():
	pass

signal player_targeting(is_targeting: bool)

func _on_char_target(charactr : Character):
	if(selected_actor != cur_turn):
		Game.err_sticker("Not their turn!", self)
		return
	if selected_action:
		selected_actor.use_ability(selected_action, charactr)
		cur_event.log_sub_event(str(selected_actor)+ " used "+ str(selected_action)+ " on "+ str(charactr))
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

func add_character(charactr : Character, set_team : int, is_NPC : bool = false) :
	var add_char_drawing : CharacterDrawing = charDrawing.instantiate()
	add_char_drawing.character = charactr
	add_char_drawing.team = set_team
	add_char_drawing.NPC = is_NPC
	add_char_drawing.position = Vector2i((randi() % 477), (randi() % 350)+50)
	if(set_team == 2):
		add_char_drawing.position.x = add_char_drawing.position.x + 477
	add_char_drawing.target.connect(Callable(self, "_on_char_target"))
	add_char_drawing.using_ability.connect(Callable(self, "_on_character_using_ability"))
	player_targeting.connect(Callable(add_char_drawing, "_on_battle_player_targeting"))
	add_child(add_char_drawing)
	if(set_team == 1):
		team1.append(add_char_drawing)
	if(set_team == 2):
		team2.append(add_char_drawing)
	add_char_drawing.char_death.connect(Callable(self, "register_char_death").bind(set_team))

func register_char_death(char, team):
	if(team == 1):
		team1.remove_at(team1.find(char))
		if(team1.is_empty()) : 
			visible = false
			$"../TextEdit".visible = true
			cur_event.open = false
			$"../TextEdit".visible = true
			cur_event.finish_event.emit()
	if(team == 2):
		team2.remove_at(team1.find(char))
		if(team2.is_empty()) : 
			visible = false
			$"../TextEdit".visible = true
			cur_event.open = false
			cur_event.finish_event.emit()
	pass
