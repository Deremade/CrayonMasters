class_name Navigation extends Control

var tiles: Array # 2D array of Tile objects
var width: int
var height: int

func _ready():
	width = get_parent().map_size.x
	height = get_parent().map_size.y
	tiles = get_parent().tiles

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
			var tile_cost = character.calc_tile_cost(tiles[next.x][next.y])
			var total_cost = current_cost + tile_cost
			# If we found a cheaper path
			if total_cost < costs[next.x][next.y]:
				costs[next.x][next.y] = total_cost
				sources[next.x][next.y] = current
				queue.append(next)

	return [sources, costs]

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

func pos_visible_from(pos : Vector2i, from : Vector2i):
	pass
