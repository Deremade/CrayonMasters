class_name Ability extends Resource
var name : String
var reach : int

func _init(set_name, set_reach):
	name = set_name
	reach = set_reach

func _to_string():
	return name

func use_ability(tile : Tile):
	pass
