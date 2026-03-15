extends Control
# Scene: event_display
# Path: res://Characters/CharInterface/note_pad.tscn
#Node Path : CharacterDrawing/NotePad
# 
# Purpose:
#   Displays character information and control options
#
# Required Nodes:
#   - NodePath: Purpose of this node
#   - NodePath: Purpose of this node
#
# Signals Connected:
#   - From : Panel -> this : _on_panel_gui_input()
#   - From : TabBar -> this : _on_tab_bar_clicked()
#   - From : Abilities/StickyNote -> this : _on_sticky_note_using_ability()
#   - From : Inventory/StickyNote -> this : _on_sticky_note_using_ability()
#
# Scene Tree Structure:
#   Root
#   ├── Panel
#   ├── TabBar
#   ├── NotePad Paper
#   ├── Main
#   |    ├── Stats
#   |    ├── Health
#   |    ├── Info
#   |    └── Head (Chataver Stick Figure)
#   ├── Abiltiies
#   ├── Inventory
#   ├── Mind
#   |    ├── Mood
#   |    ├── MoodLabel
#   |    ├── Button
#   |    └── Button2
#   ├── Log
#   └── CharacterName
#
# Modification Guidelines:
#   - NoteCardButton is it's own Node
#   - NoteCardButton also contains most of the Settings
#
# TODO:
#   - Combine invenory and ability functions (DRY principle)
##Move NotePad
var local_mouse_rel  # Local mouse position relative to the window
var drag = false  # Flag to indicate if dragging is in progress
var character : Character = null
signal using_ability(toggle : bool, ability : Ability)

##Sticky Notes
var sticky_notes = preload("res://GameInterface/StickyNote/sticky_note.tscn")

func _process(_delta):
	if(drag):
		global_position = get_global_mouse_position()-local_mouse_rel

func _on_panel_gui_input(event):
	if event is InputEventMouseButton :
		if event.pressed && event.button_index == 1:
			drag = true  # Start dragging when the mouse button is pressed
			local_mouse_rel = get_local_mouse_position()  # Set the local mouse position for dragging
		else :
			drag = false  # Stop dragging when th

func _on_tab_bar_tab_clicked(tab):
	if tab == 5 : visible = false
	$Main.visible = tab == 0
	$Abilities.visible = tab == 1
	$Inventory.visible = tab == 2
	$Mind.visible = tab == 3
	$Log.visible = tab == 4

#Receives signal from Character_Drawing
func _on_name_tag_pressed():
	visible = true
	position = Vector2(-360, -80)
	_on_tab_bar_tab_clicked(0)

func set_char(set_character : Character):
	character = set_character
	set_character.signal_damage.connect(Callable(self, "update_health"))
	#Setting up the character Graphics
	$Main/Head/Hat.texture = set_character.hat_pic
	$Main/Head/Hat.modulate = set_character.hat_color
	$CharacterName.text = "[b]"+character.char_name+"[/b]"
	####
	#Clear previous character's inventory
	for c in $Inventory.get_children():
		$Inventory.remove_child(c)
	#Set up this Character's inventory
	var item_count = 0
	for item in set_character.inventory:
		#Create anbd setup the Item
		var sticky_new = sticky_notes.instantiate()
		sticky_new.set_ability(item)
		#Place the sticky note in a grid pattern
		@warning_ignore("integer_division")
		sticky_new.position = Vector2(14 + ((item_count % 2)*150), 89 + (floor(item_count / 2))*150)
		$Inventory.add_child(sticky_new)
		item_count += 1
		#Connect to a function listed in this file
		sticky_new.using_ability.connect(Callable(self, "_on_sticky_note_using_ability"))
	#Clear Previous Characer's Abilities
	for c in $Abilities.get_children():
		$Abilities.remove_child(c)
	#Set up this Character's abiltiies
	var ability_count = 0
	for ability in set_character.abiltiies:
		#Create anbd setup the Ability
		var sticky_new = sticky_notes.instantiate()
		sticky_new.set_ability(ability)
		#Place the sticky note in a grid pattern
		@warning_ignore("integer_division")
		sticky_new.position = Vector2(14 + ((ability_count % 2)*150), 89 + (floor(ability_count / 2))*150)
		$Abilities.add_child(sticky_new)
		ability_count += 1
		#Connect to a function listed in this file
		sticky_new.using_ability.connect(Callable(self, "_on_sticky_note_using_ability"))
	update_health(0)


func _on_sticky_note_using_ability(toggle, ability):
	using_ability.emit(toggle, ability)

func update_health(_dmg):
	$Main/Health.text = "Health : "+str(character.health)
