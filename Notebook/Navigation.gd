class_name Navigation extends Control
# Class: Navigation
# Extends: Control
# Description: Hold functionality related to navigating the tilemap
#
# Properties:
#   - tiles: Array - 2D array of all tiles in the tilemap
#   - width: int - Width of tilemap
#   - height: int - Height of Tilmap
#
# Dependencies:
#   - Paper (as parent)
#
# Usage Notes:
#   - find_path requires the output of find_paths to function

var tiles: Array # 2D array of Tile objects
var width: int
var height: int

func _ready():
	width = get_parent().map_size.x
	height = get_parent().map_size.y
	tiles = get_parent().tiles

# Function: find_paths
# Description: Returns all paths a character can take on the map
# Parameters:
#   - character: Character - defines the starting point (TODO : change to Tile)
# Returns: A 2D array of Vector2is each representing the last tile the character would have been on in the shortest path from the character to the tile
# 		Expample : if returned[2][2] = Vector2i(2, 1) then the shortest path from the character to (2,2) has (2,1) as it's last step before reaching (2,2)
# Dependencies: Paper (as parent, maybe could eb passed as input to make function static?)
# Side Effects: May be computationally expensive
# Example Usage:
#   var paths = find_paths(character)
#   var path = find_path(path, Vector2i(2,2))
# Uses :
#   -map_path in Paper.gd
#
# Modification Guidelines:
#   - Remmber this returns ALL paths by calculating the "previous step" for ALL tiles
#   - TODO : Don;t return costs?
func find_paths(character: MapItem) -> Array:
	var costs = [] # 2D array of movement costs
	var sources = [] # 2D array of source tiles

	# Initialize arrays
	for x in range(width):
		costs.append([])
		sources.append([])
		for y in range(height):
			costs[x].append(INF)
			sources[x].append(null)

	# Starting position has zero cost
	var start_x = character.grid_pos.x
	var start_y = character.grid_pos.y
	costs[start_x][start_y] = 0

	var queue = []
	queue.append(Vector2i(start_x, start_y))

	# Directions for adjacent tiles
	var directions = [
		Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(0, 1), Vector2i(0, -1)
	]
	while queue.size() > 0:
		var current = queue.pop_front()
		var current_cost = costs[current.x][current.y]

		# Check all adjacent tiles
		for dir in directions:
			var next = current + dir
			# Skip if outside grid
			if next.x < 0 or next.x >= width or next.y < 0 or next.y >= height:
				continue
			#Skip starting tile
			if next.x == start_x and next.y == start_y:
				continue
			var tile_cost = character.calc_tile_cost(tiles[next.x][next.y])
			var total_cost = current_cost + tile_cost
			# If we found a cheaper path
			if total_cost < costs[next.x][next.y]:
				costs[next.x][next.y] = total_cost
				sources[next.x][next.y] = current
				queue.append(next)

	return [sources, costs]

# Function: find_path
# Description: Returns shortest path to destination given a find_paths input
# Parameters:
#   - sources: Array - first output of find_paths
#   - target: Vector2i - the destination
# Returns: An array of the sequence of Vector2i co-ordinates that make up the shortest path
# Dependencies: find_paths in this file
# Side Effects: None
# Example Usage:
#   var paths = find_paths(character)
#   var path = find_path(paths[0], Vector2i(2,2))
# Uses :
#   -map_path in Paper.gd
#
# Modification Guidelines:
#   - Remember : uses the first [0] part of find_paths
func find_path(sources: Array, target: Vector2i) -> Array:
	var path = []
	if(sources[target.x][target.y] == null):
		return []
	var current = target
	# Trace back from target to start using sources array
	while current != null:
		path.push_front(current)
		current = sources[current.x][current.y]
	return path
