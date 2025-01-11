extends TileMap

signal select_tile
var tiles = []
var map_size = Vector2i(18, 10)

func _ready():
	for x in range(map_size.x):
		tiles.append([])
		for y in range(map_size.y):
			tiles[x].append(Tile.new($Ink.get_cell_source_id(0, Vector2i(x, y))))

func _input(event):
	if event.is_action_pressed("left_click"):
		select_tile.emit(local_to_map(get_global_mouse_position()))
		var res = $Navigation.find_paths(get_parent().get_node("Icon"))
		for y in res[0]:
			print(y)
		print("\n\n")
		#for y in res[1]:
		#	print(y)
		#print("\n\n\n\n")

func map_paths(mi : MapItem):
	return $Navigation.find_paths(mi)

func map_path(mi : MapItem, destination : Vector2i):
	var paths = map_paths(mi)
	return $Navigation.find_path(paths[0], destination)
