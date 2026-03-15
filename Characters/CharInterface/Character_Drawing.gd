class_name CharacterDrawing extends Node2D
# Scene: event_display
# Path: res://Adventures/event_display.tscn
#Node Path :Open/Adventure/Events/VBoxContainer/event_display.tscn
# 
# Purpose:
#   Provides a display of the character for Events (especially Battles)
#
# Required Nodes:
#   - NodePath: Purpose of this node
#   - NodePath: Purpose of this node
#
# Signals Connected:
#   - From : NameTag -> To: NotePad : note_pad.gd : _on_name_tag_pressed()
#   - From : Target_Char -> To: _on_target_char_pressed()
#
# Scene Tree Structure:
#   Root
#   ├── Turn_Indicator
#   ├── NameTag
#   ├── Target_Char
#   ├── NotePad
#   ├── WrittenText
#   └── Head
#
# Modification Guidelines:
#   - 
#
# TODO:
#   - Remove "Head" and make it "Charctaer Profile" tscn file
#	- Remove "using ability" middleman in this file

#Set the character
@export var character : Character
#The team they are on
@export var team : int
#Weather the player can control the character
@export var NPC : bool
#How many actions they have
var actions = 1
#Signal to inform others that a acharacter has died
#connected in Battle.gd : add_character to register_char_death
signal char_death
#Signal to register the use of an ability
#Connected in Battle.gd : add_character
signal using_ability(toggled : bool, ability : Ability, char : Character)
#Signal to register the use of an ability
#Connected in Battle.gd : add_character
signal target(char : Character)

#initialize the character
func _ready():
	#Charcater Customization options
	$Head/Hat.texture = character.hat_pic
	$Head/Hat.modulate = character.hat_color
	$NameTag.text = character.char_name
	#Setting up the NotePad
	$NotePad.set_char(character)
	#Connecting the charcater's damage singal to this class' check_hp function
	character.signal_damage.connect(Callable(self, "check_hp"))

#Triggers when the note_pad using ability is triggered, emits the using_ability signal
func _on_note_pad_using_ability(toggle, ability):
	using_ability.emit(toggle, ability, self)
	pass # Replace with function body.

#Triggers whent eh Target_Char is pressed, emits the target signal
func _on_target_char_pressed():
	target.emit(character)
	pass # Replace with function body.

#emitts when the player_targeting singal is receivedfrom Battle.gd, rendered the Target_Char visible
func _on_battle_player_targeting(is_targeting):
	$Target_Char.visible = is_targeting

#Changes the characters turn
func change_turn(is_now_turn : bool):
	#Make the turn indicator visible or invisible
	$Turn_Indicator.visible = is_now_turn
	#start or end the turn
	if(is_now_turn):
		start_turn()
	else:
		end_turn()

#Check if the character died and give a status message of the current hp
func check_hp(dmg):
	if character.health <= 0:
		char_death.emit(self)
		queue_free()
		if($Turn_Indicator.visible):
			character.end_turn()
	await status_message("-"+str(dmg)+" HP : " + str(character.health))

#type_text to, then clear the $WrittenText
func status_message(text):
	await $WrittenText.type_text(text)
	await get_tree().create_timer(1).timeout
	$WrittenText.type_text("")

#Reset action counter and activate all "start of turn" effects
func start_turn():
	actions = 1
	for e in character.effects :
		e.start_turn_graphic(self)
		e.start_turn_effect(character)

#Qctivate all 'end of turn' effects and update sticky note checkboxes
func end_turn():
	for e in character.effects :
		e.end_turn_effect()
		if (e.stacks == 0):
			character.effects.remove_at(character.effects.find(e))
	if($NotePad/Abilities.has_node("StickyNote")) :
		$NotePad/Abilities/StickyNote/CheckBox.button_pressed = false
	if($NotePad/Inventory.has_node("StickyNote")) :
		$NotePad/Inventory/StickyNote/CheckBox.button_pressed = false

#Use an ability, triggered by _on_note_pad_using_ability
func use_ability(ability : Ability, ability_target: Character):
	ability.use(character, ability_target)
	actions -= 1

func _to_string() -> String:
	return str(character)
