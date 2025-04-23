class_name MapItem extends Sprite2D
# Class: MapItem
# Extends: Sprite2D
# Description: An item that apears on the map
#
# Properties:
#   - grid_pos: Vector2i - The current position of the object
#   - start_pos: Vector2i - The starting grid_pos
#
# Signals:
#   - none
#
# Dependencies:
#   - TargetCircle : child class
#
# Usage Notes:
#   - Remmeber the different ebtween grid_pos and position
#   - start_pos is an export variable
#   - grid_pos has a set function
#
# TODO:
#   - should be stored in Tile and have a referance to Tile

var grid_pos: Vector2i : set = set_grid_pos
@export var start_pos: Vector2i

func _ready():
	grid_pos = start_pos

# Function: set_grid_pos
# Description: Changes the grid_pos of the item
# Parameters:
#   - new_pos: Vector2i - the new position of the item
# Returns: void
# Dependencies: none
# Side Effects: changes the position of the mapitem
# Example Usage:
#   character.grid_pos = Vctor2i(x, y)
# Uses :
#   -_ready : Charcter.gd
#   -continue_path, _ready : Charcter.gd
#
# Modification Guidelines:
#   - Remember to keep th position relativr to the tileset
func set_grid_pos(new_pos: Vector2i):
	grid_pos = new_pos
	position = (grid_pos * 64) + Vector2i(32, 32)

#Playr functions : Functiosn thre soley for the player

# Function: player_targeted
# Description: Maks the item targetable by the player and shows the player they can be targeted
# Parameters:
#   - is_target: bool - True : make the targt cirlce visible, fale : hide the circle
# Returns: void
# Dependencies: $TargetCircle
# Side Effects: Maks TargetCircle visible or invisible
# Uses :
#   -player_selects_ability, finish_ability in Character.gd
#   -select_interact in NotCard.gd
func player_targeted(is_target):
	$TargetCircle.visible = is_target

# Function: can_target
# Description: Checkes if the item can be targeted
# Returns: void
# Dependencies: $TargetCircle
# Side Effects: none
# Uses :
#   -_on_notebook_select_map_item in NotCard.gd
func can_target() -> bool:
	return $TargetCircle.visible
