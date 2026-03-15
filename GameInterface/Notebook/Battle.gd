extends Control
#Current selections
var selected_actor : CharacterDrawing
var selected_action : Ability
var cur_event : Event
#Graphics
var charDrawing = preload("res://Characters/CharInterface/CharacterDrawing.tscn")
#The two teams of the battle
var team1 = []
var team2 = []
#Keeping track fo the current turn
var cur_turn:
	#If the current turn changes
	set(next_turn):
		#Clear current turn
		if(cur_turn):
			cur_turn.change_turn(false)
		#Set up the new turn
		cur_turn = next_turn
		cur_turn.change_turn(true)
		#If there are no action; skip the turn (Needed becuase turn normally ends upon taking action)
		if(cur_turn.actions == 0):
			go_next_turn()
		

func _ready():
	pass

signal player_targeting(is_targeting: bool)

#When the player hits the little target icon
func _on_char_target(charactr : Character):
	#Don't let the player play out of turn
	if(selected_actor != cur_turn):
		Game.err_sticker("Not their turn!", self)
		return
	#If an action is selected when they target a character
	if selected_action:
		selected_actor.use_ability(selected_action, charactr)
		cur_event.log_sub_event(str(selected_actor)+ " used "+ str(selected_action)+ " on "+ str(charactr))
	#End turn if there are no more actions
	if(selected_actor.actions == 0):
		go_next_turn()

#When a player selects their ability
#Connected in add_character
func _on_character_using_ability(toggled, ability, charactr):
	 #Handled in char_drawing renderes the Target_Char visible
	player_targeting.emit(toggled)
	#If the player selected an ability : set current selections
	if toggled:
		selected_action = ability
		selected_actor = charactr
	#If a player unslected an ability : Remove current selections
	else:
		selected_action = null
		selected_actor = null 

#Advance the turn orser
func go_next_turn():
	#TODO : There must be a more efficent way
	var children = get_children()
	var next_num = children.find(cur_turn)+1
	next_num = next_num % len(children)
	cur_turn = children[next_num]

#Adding a character to the battle
#Called in Combat_Event : add_characters
func add_character(charactr : Character, set_team : int, is_NPC : bool = false) :
	#Setup the Character Drawinf
	var add_char_drawing : CharacterDrawing = charDrawing.instantiate()
	add_char_drawing.character = charactr
	add_char_drawing.team = set_team
	add_char_drawing.NPC = is_NPC
	#Place the drawing
	add_char_drawing.position = Vector2i((randi() % 477), (randi() % 350)+50)
	if(set_team == 2): #If on the "2nd" team, move char to right side of book
		add_char_drawing.position.x = add_char_drawing.position.x + 477
	#Connect relevent signals
	add_char_drawing.target.connect(Callable(self, "_on_char_target")) #When the player clicks on their target
	add_char_drawing.using_ability.connect(Callable(self, "_on_character_using_ability")) #Whent he player selects one of their abilitys
	player_targeting.connect(Callable(add_char_drawing, "_on_battle_player_targeting")) #player_tagreting : The signal to reveal the targets
	add_char_drawing.char_death.connect(Callable(self, "register_char_death").bind(set_team)) #Register when the character died
	#Add the character to the battlefeild and to a team
	add_child(add_char_drawing)
	if(set_team == 1):
		team1.append(add_char_drawing)
	if(set_team == 2):
		team2.append(add_char_drawing)

#Function actgivated when this class receives the "char_death" signal
func register_char_death(charactr, team):
	var team_list
	#Find team that lost a guy
	if(team == 1): team_list = team1
	if(team == 2): team_list = team2
	team_list.remove_at(team1.find(charactr))
	#if nobody is left on that team; battle ends
	if(team_list.is_empty()) : 
		visible = false
		$"../TextEdit".visible = true
		cur_event.open = false
		cur_event.finish_event.emit()
	pass
