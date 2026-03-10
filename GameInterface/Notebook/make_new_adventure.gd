extends Control
var genre = Genre.new()
#When the player clickes the button to create a new adventure based on text input
func _on_button_pressed() -> void:
	#If the Adventure was unnamed; give error
	if $TextEdit.text == "" :
		print(Game.err_sticker("Please enter a name for the new Adventure", self))
		return
	#Init new adventure
	var new_adventure = Adventure.new($TextEdit.text, genre)
	$"../Sagas".add_adventure(new_adventure)
	#Clear text input
	$TextEdit.text = ""
	#Create Adventue button : Will be used to select the current Adventure
	var adventure_button = Button.new()
	adventure_button.text = new_adventure.name
	$List.add_child(adventure_button)
	adventure_button.pressed.connect(Callable(self, "select_adventure").bind(new_adventure))

func select_adventure(a : Adventure):
	$"../../../Adventure".set_adventure(a)
