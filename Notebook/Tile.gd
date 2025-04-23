class_name Tile
# Class: Tile
# Extends: None
# Description: Holds all the information that would b held ina single tile of the game map
#
# Properties:
#   - cost: numbr - Cost of moving through this tile (DO NOT USE INT :MESSES UP THE INF)
#   - property2: Type - Description
#
# Signals:
#   - change_type(tile): emitted when the tile changes proprties so the Paper can update graphics and info
#
# Dependencies:
#   - Paper
#
# Usage Notes:
#   - atlas = the graphics used by the Ink TileSet
#   - pos = Position on the grid of Paper
#
# TODO:
#   - Replace cost varibale with function that is character specific
var cost = 1
var atlas
signal change_type
var pos : Vector2i

# Function: _init
# Description: Constructor class for Tile
# Parameters:
#   - set_pos: Vctor2i - set the grid position of the tile
#   - set_atlas: int - set the "Style" or "Sprite" of the tile basd on the Ink Tileset
#   - paper: Paoer - the Papr (for conencting the change_tile) signal
# Dependencies: Paper
# Side Effects: sets all variabls initial configuration
# Example Usage:
#   Tile.new(Vctor2i(0,0), 0, this)
# Uses :
#   -_ready : Paper.gd
#
# Modification Guidelines:
#   - Check if th atlas of Ink matches
#   - Make sure the change_tile signal is still connected
func _init(set_pos : Vector2i, set_atlas : int, paper : Paper):
	change_type.connect(Callable(paper, "change_tile"))
	atlas = set_atlas
	pos = set_pos
	if(atlas == 0):
		cost = INF
	if(atlas == 1):
		cost = 2

# Function: is_visible
# Description: Returns weather the tile is see-through or not
# Returns: bool - can th tile be seen through
# Dependencies: cost
# Side Effects: none
# Uses :
#   -is_visible_from : Paper.gd
#
# Modification Guidelines : None
func is_visible():
	return cost != INF

# Function: change_tile
# Description: Function to change aspects of the tile (specifically the atlas)
# Parameters:
#   - param1: Type - Description of parameter
#   - param2: Type - Description of parameter
# Returns: Return type - What the function returns
# Dependencies: List any dependencies or required nodes
# Side Effects: Describe any side effects or state changes
# Example Usage:
#   var result = function_name(param1, param2)
# Uses :
#   -List places where the function is invoked
#
# Modification Guidelines:
#   - Make sure th change_type signal is emitted so the PAper can chnage the graphics
func change_tile(new_atlas):
	atlas = new_atlas
	if(atlas == 0):
		cost= INF
	if(atlas == 1):
		cost = 2
	change_type.emit(self)
