class_name Paper extends TileMap
# Class: Paper
# Extends: TileMap
# Description: The paper, deals with the Tilemap functionalities
#
# Properties:
#   - tiles: Array - 2D array lsiting all tiles as Tiles
#   - map_size: Vector2i - the size of the map
#
# Signals:
#   - select_tile(Tile): When a player clicks on a tile
#   - select_map_item(item): When a player clicks on a MapItem
#
# Dependencies:
#   - List required scenes/resources
#   - List required autoloads
#
# Usage Notes:
#   - Paper Tileset holds tiles for "paper" background
#   - Ink Tileset holds the ink drawn sprites

signal select_tile
signal select_map_item
var tiles = []
var map_size = Vector2i(17, 10)

# Function: _ready
# Description: Setup function automatically triggered when loaded
# Returns: void
# Dependencies: $Ink
# Side Effects: Fills tiles[] with Tiles
# Modification Guidelines:
#   - Uses $Ink to set tile proprties
func _ready():
	for x in range(map_size.x):
		tiles.append([])
		for y in range(map_size.y):
			tiles[x].append(Tile.new(Vector2i(x, y), $Ink.get_cell_source_id(0, Vector2i(x, y)), self))

# Function: _unhandled_input
# Description: Handles clicking on tiles
# Parameters:
#   - event: ? - The event/input
# Returns: void
# Dependencies: none
# Side Effects: emits the select_tile and select_map_item signals
func _input(event):
	#Prevent erros by ensuring the mouse is in the right area
	if(not get_parent().mouse_in):
		return
	#If Left Click
	if event.is_action_pressed("left_click"):
		#Find the grid_positiona nd emit the signal that the tile has been selected
		var grid_position = global_to_grid(get_global_mouse_position())
		if(grid_position.x >= map_size.x) : return
		if(grid_position.y >= map_size.y) : return
		select_tile.emit(tiles[grid_position.x][grid_position.y])
		#Iterate through clickable items and emit a signal if they are on the same tile
		for item in get_parent().turns:
			if(item.grid_pos == grid_position):
				select_map_item.emit(item)
				print(item)
		for item in get_parent().interactables:
			if(item.grid_pos == grid_position):
				select_map_item.emit(item)

# Function: map_paths
# Description: Middleman function to call Navigation find_paths and find_path functions
# Parameters:
#   - mi: MapItem - The item that is trying to find paths (Might change to origin psoition)
#   - destination: Tile - mi's destination
# Returns: Array of points that make a path from origin to destination
# Dependencies: $Navigation as child node
# Side Effects: None
# Example Usage:
#  var paths = map_paths(mi)
# Uses :
#   -_on_paper_select_tile : Character.gd
# Modification Guidelines:
#   - TODO : Might change to position or even cut out middleman entirely
func map_path(mi : MapItem, destination : Tile):
	var paths = $Navigation.find_paths(mi)
	return $Navigation.find_path(paths[0], destination.pos)

# Function: is_visible_from
# Description: Brief description of what the function does
# Parameters:
#   - start: Vector2i - Place the function checks if the target is visible from
#   - target: Vector2i - Place the function checks is visible from start
# Returns: bool - Is th target visible or not
# Dependencies: Tile (is_visible function), tiles (array in this file)
# Side Effects: None
# Example Usage:
#   if(is_visible_from(here, target)) : #Attack
# Uses :
#   -can_target : this file
#
# Modification Guidelines: None
func is_visible_from(start: Vector2i, target: Vector2i) -> bool:
	# Get the difference between start and target
	var dx = abs(target.x - start.x)
	var dy = abs(target.y - start.y)
	
	var x = start.x
	var y = start.y
	
	var step_x = 1 if target.x > start.x else -1
	var step_y = 1 if target.y > start.y else -1
	var err = dx - dy
	
	while x != target.x or y != target.y:
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x += step_x

		if e2 < dx:
			err += dx
			y += step_y
			
		# Skip checking the target tile itself
		if x == target.x and y == target.y:
			break
			
		# If we hit a wall, return false
		if not tiles[x][y].is_visible():
			return false
	
	return true

# Function: can_target
# Description: Brief description of what the function does
# Parameters:
#   - start: Vector2i - The orgin point
#   - target: Vector2i - The point bing targted
#   - reach: int - Max Range
# Returns: bool - If the target can be targeted from the origin
# Dependencies: is_visible_from : this file
# Side Effects: None
# Example Usage:
#   var result = function_name(param1, param2)
# Uses :
#   -viable_targets, interactiables : Notbook
#
# Modification Guidelines:
#   - Do not confuse with can_target from MapItem (TODO : change one of their names)
func can_target(start : Vector2i, target: Vector2i, reach : int) -> bool:
	if((start-target).length() <= reach):
		return is_visible_from(start, target)
	return false

# Function: change_tile
# Description: recives a singal to change a tile's Ink
# Parameters:
#   - tile: Tile - The tile that changed
# Returns: void
# Dependencies: $Ink
# Side Effects: Changes the $Ink tile
# Uses :
#   -change_tile : Tile.gd (Via signal)
#
# Modification Guidelines:
#   - Takes signal from Tile.gd, changes $Ink
#   - Remember atlas variables
func change_tile(tile : Tile):
	$Ink.set_cell(0, tile.pos, tile.atlas, Vector2i(0,0))

# Function: global_to_grid
# Description: Converst a global position to grid position
# Parameters:
#   - input: Vector2 - The inpur global vector
# Returns: Vector2i - The grid position
# Dependencies: to_local, local_to_map
# Side Effects: None
# Example Usage:
#   var grid_position = global_to_grid(get_global_mouse_position())
# Uses :
#   -_input
#
# Modification Guidelines:
#   - Remember tha the grid posiion is relative to the global posiiton and scale of the node (and parent nodes all the way up)
func global_to_grid(input : Vector2) -> Vector2i:
	# Get the global position
	var global_click_pos = input
		
	# Convert global position to TileMap's local coordinate space
	var local_click_pos = to_local(global_click_pos)
		
	# Get the tile grid position
	var tile_pos = local_to_map(local_click_pos)
	return tile_pos
