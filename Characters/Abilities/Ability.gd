class_name Ability extends Resource
# Class: Ability
# Extends: Resource
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
func _init(set_ability_name : String, set_reach : int):
	name = set_ability_name
	reach = set_reach

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
	pass

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
	_char.dmg((randi() % 10)+1)
	pass

func _to_string():
	return name
