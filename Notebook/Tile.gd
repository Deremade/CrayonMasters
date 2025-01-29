class_name Tile

var cost = 1

func _init(atlas):
	if(atlas == 0):
		cost= INF
	if(atlas == 1):
		cost = 2

func is_visible():
	return cost != INF
