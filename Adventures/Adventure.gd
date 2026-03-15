class_name Adventure extends Resource

var genre : Genre
var name : String
#List of events [Currently only suited for chronological stories]
#Currently unused
var events : Array[Event] = []

func _init(set_name : String, set_genre : Genre) -> void:
	name = set_name
	genre = set_genre

#A list of all characters, emits a signal when updated
#signal connects to event_display.gd : update_characters
#					adventureSettings.gd : update_characters
#Signal connects on adventure_events.gd: _on_button_pressed
#					adventureSettings.gd : set_adventure
var Characters : Array[Character] = []:
	set(chars):
		Characters = chars
		characters_updated.emit(Characters)
signal characters_updated

#Adds a character to the Adventure
#Called on adventure_characters.gd:_on_button_pressed
func add_character(char):
	Characters.append(char)
	characters_updated.emit(Characters)
