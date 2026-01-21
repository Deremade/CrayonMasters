class_name Adventure extends Resource

var genre : Genre
var name : String
var events : Array[Event] = []
var select_button : Button

func _init(set_name : String, set_genre : Genre) -> void:
	name = set_name
	genre = set_genre

func get_button():
	if select_button == null:
		select_button = Button.new()
		select_button.text = name
		select_button.pressed.connect(Callable(self, "test_button"))
	return select_button

func test_button():
	pass

var Characters : Array[Character] = []:
	set(chars):
		Characters = chars
		characters_updated.emit(Characters)
		print("Update Charcaters")
signal characters_updated

func add_character(char):
	Characters.append(char)
	characters_updated.emit(Characters)
	print("Add")
