class_name Ability extends Resource

@export var name : String
#Texture that shows up on sticky notes
@export var texture : Texture2D

#Defines the settings that can be changed on a notecard
#Example : {"Source" : ["Arcana", "Psychic", "Patron"]}
var settings = {}
#Holds the settings the user chose
#Example : {"Source" : "Arcana"}
var changes = {}

func _init(set_ability_name : String, png_file : String):
	name = set_ability_name
	texture = ImageTexture.create_from_image(Image.load_from_file(png_file))

#Function to use the ability, abstrcat function to be filled in by subclassess
#Called in CharacterDrawing.gd : use_ability
func use(_actor : Character, _target : Character):
	pass

func _to_string() -> String:
	return name
