class_name Ability
# Class: Ability
# Extends: nothing
# Description: Holds all the information for actions preformed by characters
#
# Properties:
#   - name: String - Name that apears on the UI
#   - reach: int - Max range of the ability from the character
#
# Signals:
#   - none
#
# Dependencies:
#   - Tile : although notyer implemented
#
# Usage Notes:
#   - Unfinished

var name : String
var reach : int
var range : int
signal clear_ability
signal use_ability
var primary_tile :Tile
var other_affected_tiles = []

# Function: _init
# Description: Constructor Function
# Parameters:
#   - set_ability_name: String - Name of Ability
#   - set_reach: int - Reach
# Returns: void
# Dependencies: None
# Side Effects: Creates Ability with basic 
# Example Usage:
#   var melee = _init("Melee Weapon", 1)
#   var melee = _init("Ranged Weapon", 10)
#
# TODO:
#   - Expand so a dictionary can be inserted to construct the ability
func _init(set_ability_name : String, set_reach : int, set_range : int = 0):
	name = set_ability_name
	reach = set_reach
	range = set_range

# Function: use_ability_on_tile
# Description: Abstract function that activates the effect of the ability
# Parameters:
#   - tile: Tile - Description of parameter
# Returns: void
# Dependencies: Tile class
# Side Effects: NA
# Uses : _on_paper_select_tile in Character class
#
# TODO: expand to include an effect_character() function that grabs charactr from Tile
func use_ability_on_tile(_tile : Tile):
	primary_tile = _tile
	primary_tile.highlight_tile(Color.RED, clear_ability)
	use_ability.emit()
	if(range < 1): return
	other_affected_tiles = _tile.get_tiles_in_range(range)
	for a in other_affected_tiles:
		a.highlight_tile(Color.RED, clear_ability)

func execute_ability():
	affect_tile(primary_tile)
	print(other_affected_tiles)
	for a in other_affected_tiles:
		print(a.pos)
		affect_tile(a)
	clear_ability.emit()
	pass

func affect_tile(_tile : Tile):
	var target_char = _tile.get_character()
	if(not target_char == null):
		use_ability_on_char(target_char)
# Function: use_ability_on_char
# Description: Abstract function that activates the effect of the ability
# Parameters:
#   - char: Character - Description of parameter
# Returns: void
# Dependencies: Tile class
# Side Effects: NA
# Uses : char_use_ability in Character class
#
# TODO: expand to include an effect_character() function that grabs charactr from Tile
func use_ability_on_char(_char : Character):
	pass

func _to_string():
	return name
