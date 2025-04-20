extends TileMap

signal select_tile
signal select_map_item
var tiles = []
var map_size = Vector2i(18, 10)

func _ready():
	for x in range(map_size.x):
		tiles.append([])
		for y in range(map_size.y):
			tiles[x].append(Tile.new(Vector2i(x, y), $Ink.get_cell_source_id(0, Vector2i(x, y)), self))

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		var grid_position = local_to_map(get_global_mouse_position())
		select_tile.emit(tiles[grid_position.x][grid_position.y])
		for item in get_parent().turns:
			if(item.grid_pos == grid_position):
				select_map_item.emit(item)
		for item in get_parent().interactables:
			if(item.grid_pos == grid_position):
				select_map_item.emit(item)

func map_paths(mi : MapItem):
	return $Navigation.find_paths(mi)

func map_path(mi : MapItem, destination : Tile):
	var paths = map_paths(mi)
	return $Navigation.find_path(paths[0], destination.pos)

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

func can_target(start : Vector2i, target: Vector2i, reach : int) -> bool:
	if((start-target).length() <= reach):
		return is_visible_from(start, target)
	return false

func change_tile(tile : Tile):
	print(tile.atlas)
	$Ink.set_cell(0, tile.pos, tile.atlas, Vector2i(0,0))
	pass
