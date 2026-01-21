class_name Ability extends Resource

@export var name : String
@export var texture : Texture2D

var settings = {}
var changes = {}

func _init(set_name : String, png_file : String):
	name = set_name
	texture = ImageTexture.create_from_image(Image.load_from_file(png_file))

func use(_actor : Character, _target : Character):
	pass

func _to_string() -> String:
	return name
