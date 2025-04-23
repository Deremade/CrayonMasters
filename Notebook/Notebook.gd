class_name NoteBook extends Node2D
# Class: NoteBook
# Extends: Node2D
# Description: Acts as the primary node for the Notboo.tscn file and holds basic Notebook functionality
#
# Properties:
#   - turns: Array - Holds all Characters in the turn order
#   - interactables: Array - Hold all interactables
#   - cur_turn: int - keps track of where in th turn order the current turn is
#
# Signals:
#   - select_map_item(item): Emited when select_map_item is rived from paper, not currently useful
#
# Dependencies:
#   - List required scenes/resources
#   - List required autoloads
#
# Usage Notes:
#   - Mostly acts as a middle man or "observer"

# Scene: NoteBook
# Path: res://path/to/scene.tscn
# 
# Purpose:
#   Describe the main purpose of this scene/node
#
# Required Nodes:
#   - Paper: Holds the paper for the NoteBook, runs most "board" functionality
#
# Signals Connected:
#   - From -> To: Description of connection
#
# Scene Tree Structure:
#   Notebook
#   ├── Paper
#   │   ├── Ink
#   │   └── Navigation
#   └── Character
#
# Modification Guidelines:
#   - Check that all characters are in turns array
#   - Check that all characters have their change_turn signsal connected
#
# TODO:
#   - Add auto-character and auto-interactable addition function


@onready var turns = [$Icon, $Icon2]
@onready var interactables = [$Sprite2D]
var cur_turn = 0
signal select_map_item

func _ready():
	turns[0].is_turn = true

# Function: _on_icon_change_turn
# Description: Handles turn order operations when it receives an "end turn" or "start turn" signal
# Parameters:
#   - is_turn: bool - Wather it is starting (true) or ending (false) the turn
# Returns:  void
# Dependencies: cur_turn
# Side Effects: changes cur_turn, changes is_turn to true for the next character's turn
# Example Usage:
#   var result = function_name(param1, param2)
# Uses :
#   -receives signal from set_turn : Character.gd
# Modification Guidelines:
#   -None
func _on_icon_change_turn(is_turn : bool):
	if is_turn:
		return
	cur_turn = (cur_turn + 1)  % len(turns)
	#Remember : is_turn for Characters has a set function (set_turn)
	turns[cur_turn].is_turn = true

# Function: _on_paper_select_map_item
# Description: Acts as middle man between the paper selecting a map_item and emiting a singal from the notebook
# Parameters:
#   - item : MapItm - Item being slected
# Returns: emits select_map_item
# Dependencies: Paper
# Side Effects: emits select_map_item
# Example Usage:
#   var result = function_name(param1, param2)
# Uses :
#   -_on_notebook_select_map_item in NoteCard.gd (receives signal)
#   -_unhandled_input in Paper.gd (mits signal)
# Modification Guidelines:
#   - Is a middleman fucntion
func _on_paper_select_map_item(item):
	select_map_item.emit(item)

# Function: viable_targets
# Description: Grabs the list of characters, and returns all characters that can be targeted from a starting poosition
# Parameters:
#   - start: Vector2i - The starting position
#   - reach: int - the max range
# Returns: Array of characters
# Dependencies: $Paper as child node
# Side Effects: Describe any side effects or state changes
# Uses :
#   -get_characters : Character.gd
#
# Modification Guidelines:
#   - Will likely be removed entirely in favor of a more Ability specifc system
func viable_targets(start : Vector2i, reach  : int = -1):
	var viable = []
	#Assume a -1 means "Infinite range"
	if(reach == -1):
		return turns
	#Get all characters see if they are in range
	for character in turns:
		if($Paper.can_target(start, character.grid_pos, reach)):
			viable.append(character)
	return viable

# Function: viable_targets
# Description: Grabs the list of InteractableItems, and returns all items that can be targeted from a starting poosition
# Parameters:
#   - start: Vector2i - The starting position
#   - reach: int - the max range
# Returns: Array of characters
# Dependencies: $Paper as child node
# Side Effects: Describe any side effects or state changes
# Uses :
#   -get_interactables : Character.gd
#
# Modification Guidelines:
#   - None
func interactiables(start, reach):
	var viable = []
	for i in interactables:
		if($Paper.can_target(start, i.grid_pos, reach)):
			viable.append(i)
	return viable
