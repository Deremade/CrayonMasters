class_name Tile

var cost = 1
var atlas
signal change_type
var pos : Vector2i

func _init(set_pos, set_atlas, paper):
	change_type.connect(Callable(paper, "change_tile"))
	atlas = set_atlas
	pos = set_pos
	if(atlas == 0):
		cost= INF
	if(atlas == 1):
		cost = 2

func is_visible():
	return cost != INF

func change_tile(new_atlas):
	atlas = new_atlas
	if(atlas == 0):
		cost= INF
	if(atlas == 1):
		cost = 2
	change_type.emit(self)
