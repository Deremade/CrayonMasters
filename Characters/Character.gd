class_name Character extends MapItem
# Class: Charcter
# Extends: MapItem
# Description: Represents a game character
#
# Properties:
# 	Movement:
#   - cur_path: Array - Holds Vector2i representations of the grid positions of th character's current path, calculated in the _on_paper_select_tile function
#   - moves: int - Character speed (nuymber fo tiles they can mvoe ina  turn, is decremented each tile they ove reset evry turn
#   - is_moving: bool - Keeps track fo if the payer is moving the character, so the path can be set if the player clicks on a tile
#        TODO : Move this functionality to the NoteCard class
# 	Actions:
#   - actions: int - Hold the number of actions that can be preformed in a turn, decrements each action and rests every turn
#   - selcted_ability: Ability - Holds the currently selected Ability to use
# 	Turns:
#   - is_turn: bool - Keeps track of weather it is their turn or not (so they can act, reset per turn proprties, etc)
# 	Character Info: Will b expanded to include stats, abilities and behavioral parameters
#   - char_name: String - name of the character
#
# Signals:
#   - change_turn(is_turn): Signals when their turn starts and ends
#
# Dependencies:
#   - Ability Class
#   - Character.tscn Scene
#	- Parent must be Notebook (has many get_parent() calls) TODO : Fix this dependancy
#
# Usage Notes:
#   - Runs from the Character.tscn File
#   - Must be child of Notebook
#   - Name of character set as export variable

# Scene: Character
# Path: res://Characters/Character.tscn
# 
# Purpose:
#   Represent a game Character
#
# Required Nodes:
#   - Notebook: Parent node, hold information the Character needs such as other characters, interactables and map paths
#   - Timer: Smooth animation when moving
#   - TargetCircle: So player can target, (Visial indication) TODO : There must be a better way
#   - RichTextLabel: Display character name
#
# Signals Connected:
#   - From -> To: Description of connection
#
# Scene Tree Structure:
#   NoteBook
#   ├── Paper
#   ├── Character <- This Node
#   │   └── Timer
#   │   └── RichTxtLabl
#   │   └── TargetingCircle
#   └── OtherCharacters
#
# Modification Guidelines:
#   - get_parent() should return anotebook ro b replaced by something that returns a notebook
#   - Remmeber Tile vs grid_pos - TODO : There must be a better way
#
# TODO:
#   - All Actions should be moved from NoteCard to here
#   - A better ways to gather information from the rest of the game (From the notebook)

#Movement
var cur_path : Array
var moves = 5
var is_moving : bool = false
#Actions
var actions = 1
var selcted_ability : Ability
#Turns
var is_turn : bool = false : set = set_turn
signal change_turn
#Character info
@export var char_name : String

################################################################################

#Generic Functions

func _to_string():
	return char_name

# Function: _ready
# Description: Runs when the scene is loaded, just ensures proper setup
# Parameters: none
# Returns: void
# Dependencies: RichTextLabel
# Side Effects:
#   - Changes grid_pos to the start_pos (Defined in Parent class MapItem)
func _ready():
	grid_pos = start_pos
	$RichTextLabel.text = char_name

################################################################################

# Movement Functions

# Function: function_name
# Description: Brief description of what the function does
# Parameters: none
# Returns: void
# Dependencies: MapItem, cur_path, Timer
# Side Effects: Changes the Charactr's position and modifies their path
# Uses :
#   -_on_timer_timeout : this file
# Modification Guidelines:
#   - grid_pos has set function in MapItem (the parent class)
func continue_path():
	#If there ar moves left and a path to move on
	if(moves > 0 && cur_path != []):
		#Change grid position to that class (see parent class)
		grid_pos = cur_path[0]
		#Remove the tile the character moved to from the path
		cur_path.remove_at(0)
		#Decrement moves left
		moves -= 1
	else: #If there are no moves left or no path left, stop the timer
		$Timer.stop()

# Function: start_movement
# Description: Starts the chacter movement squence
# Parameters: none
# Returns: None
# Dependencies: List any dependencies or required nodes
# Side Effects: Activates Timer which connects to _on_timer_timeout
# Uses :
#   -_on_paper_select_tile : This file
#   -set_turn : This file
# Modification Guidelines:
#   - Keep the $Timer in mind
#   - $Timer activates _on_timer_timeout
func start_movement():
	$Timer.start()

# Function: function_name
# Description: Invokes continue_path, honestly could be vut out as the middle man, not sure why it's hre
# Parameters: none
# Dependencies: $Timer
# Side Effects: invokes continue_path
# Uses :
#   -Invoked when $Timer goes out (started in start_movement)
# Modification Guidelines:
#   - Not sure why it's even here
#   - If removed, reconnect $Timer signal to continue_path
func _on_timer_timeout():
	continue_path()

# Function: calc_tile_cost
# Description: Returns the navigation cost of a tile the character wants to move through
# Parameters:
#   - tile: Tile - The tile in question
# Returns: int (Cost of moving through that tile, navigation cost, not movement cost)
# Dependencies: Tile Class
# Side Effects: None
# Example Usage:
#   var tile_cost = character.calc_tile_cost(tiles[next.x][next.y])
# Uses :
#   -find_paths in Navigation.gd
#
# Modification Guidelines:
#   - Is only here so it can be modifed when characters have more unique movement
#   - Might be replaaced by having the Tile class handl it instead
#   - Returns Navigation cost not movement cost
func calc_tile_cost(tile : Tile):
	return tile.cost


################################################################################

# Turns

# Function: set_turn
# Description: Set function for is_turn
#   - Resets all turn based stats
#   - Handles end of tunr cleanup
# Parameters:
#   - turn: bool - Is it the character's turn or not
# Returns: void
# Dependencies:
# Side Effects: emits change_turn signal
# Example Usage:
#   Character.turn = true
# Uses :
#   -Notebook.gd : _ready, _on_icon_change_turn
#   -NoteCard.gd : _on_button_pressed
#
# Modification Guidelines:
#   - Signal is emitted to Notebook
func set_turn(turn : bool):
	#If the turn starts
	if(turn):
		moves = 5
		actions = 1
	else : #If the turn ends
		if(cur_path != []): #Finish unfinished movement
			start_movement()
		#Disable player control
		is_moving = false 
		player_deselects_ability()
	#Emit the chang turn signal so (mostly) Notebook can handle turn order operations
	change_turn.emit(turn)
	is_turn = turn

################################################################################

# Abilties

# Function: char_use_ability
# Description: Function used by the character to use an ability
# Parameters:
#   - target: Character - Charater whom th ability will be used on
# Returns: void
# Dependencies: None (Character?)
# Side Effects: decrements actions
# Example Usage:
#   selected.char_use_ability(item)
# Uses :
#   -NoteCard.gd : _on_notebook_select_map_item
#
# Modification Guidelines:
#   - Takes Character as parameter
#   - Only prints
# TODO:
#   - tgarget should be a tile not a character (will rquire modifying the Tile class)
func char_use_ability(target : Character):
	if(actions > 0):
		print(self, " uses ", selcted_ability, " on ", target)
		actions -= 1
	else :
		print("NO ACTIONS AVAILABLE")

# Function: finish_ability
# Description: Clean=up when an ability finishes
# Parameters:
#   - targets: Array - array of targets who need to be cleared from being targeted
# Returns: Return type - What the function returns
# Example Usage:
#   finish_ability(get_characters())
# Uses :
#   -player_deselects_ability
#
# Modification Guidelines:
#   - Turns off player targeting ; need alternative way of doing this if removed
func finish_ability(targets):
	for t in targets:
		t.player_targeted(false)

# Function: char_interact
# Description: Interact with intractable items
# Parameters:
#   - item: Interactable - Description of parameter
# Returns: void
# Dependencies: Interactable
# Side Effects: invokes the interact() function from InteractableItem.gd
# Uses :
#   -NoteCard.gd : _on_notebook_select_map_item
# Modification Guidelines:
#   - Most functionality ishandled in InteractableItem.gd
func char_interact(item : Interactiable):
	item.interact(self)

################################################################################

#Information Gathering
# TODO : update base information from notebook whn a signal comes from notebook, handle filtering here

# Function: get_characters
# Description: Asks the notebook what other characters are on the map within a range
# Parameters:
#   - reach: int - the range of the search
# Returns: Array - List of characters
# Dependencies: Notebook
# Side Effects: None
# Example Usage:
#    var targets = get_characters(5) #Get all characters within 5 tiles
# Uses :
#   -player_selects_ability : This file
#   -player_deselects_ability : This file
# Modification Guidelines:
#   - get_parent() refers to the notebook
func get_characters(reach : int = -1) -> Array:
	return get_parent().viable_targets(grid_pos, reach)

# Function: get_interactables
# Description: Asks the notebook what nteractables are on the map within a range
# Parameters:
#   - reach: int - the range of the search
# Returns: Array - List of interactables
# Dependencies: Notebook
# Side Effects: None
# Example Usage:
#   var items = get_interactables(1) #Gets all adjacent interactables
# Uses :
#   -player_selects_ability : This file
#   -player_deselects_ability : This file
# Modification Guidelines:
#   - get_parent() refers to the notebook
func get_interactables(reach):
	return get_parent().interactiables(grid_pos, reach)

################################################################################

#Player Intractions

# Function: _on_paper_select_tile
# Description: Receives the singal "paper_select_tile" from Paper
# Parameters:
#   - t: Tile - the selected tile
# Returns: void
# Dependencies: Tile, Notebook (parent), Paper
# Side Effects: activates start_movement(), can activate selected_ability.use_ability()
# Uses :
#   -_unhandled_input from Paper.gd
# Modification Guidelines:
#   - Uses path from Parent node to find "Paper"
func _on_paper_select_tile(t : Tile):
	#If the mvoing checkbox is sleected, set the character path to the selected tile
	if(is_moving):
		cur_path = get_parent().get_node("Paper").map_path(self, t)
		start_movement()
	#If some ability is selected, use the ability
	if(selcted_ability != null):
		selcted_ability.use_ability(t)

# Function: player_selects_ability
# Description: Selects ana bility for use
# Parameters:
#   - a: Ability - Th ability slected on the NotCard
# Returns: Return type - What the function returns
# Dependencies: get_characters(), Ability
# Side Effects: Sets the selected_ability
# Uses :
#   -on_check in NoteCard.gd
# Modification Guidelines:
func player_selects_ability(a : Ability):
	selcted_ability = a
	for pt in get_characters(a.reach) :
		pt.player_targeted(true)

# Function: player_selects_ability
# Description: Clears a selected ability
# Returns: Return type - What the function returns
# Dependencies: get_characters(), finish_ability()
# Side Effects: Clears the selected_ability to null
# Uses :
#   -on_check in NoteCard.gd
# Modification Guidelines:
func player_deselects_ability():
	selcted_ability = null
	finish_ability(get_characters())
