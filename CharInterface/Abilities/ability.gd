class_name Ability extends Resource

@export var name : String
@export var texture : Texture2D

var settings = {}
var changes = {}

func use(actor : Character, target : Character):
	print(actor.char_name, " used ", name, " on ", target.char_name)
