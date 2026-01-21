extends Control
var genre = Genre.new()

func _on_button_pressed() -> void:
	if $TextEdit.text == "" :
		print(Game.err_sticker("Please enter a name for the new Adventure", self))
		return
	var new_adventure = Adventure.new($TextEdit.text, genre)
	$"../Sagas".add_adventure(new_adventure)
	$TextEdit.text = ""
	$List.add_child(new_adventure.get_button())
	new_adventure.get_button().pressed.connect(Callable(self, "select_adventure").bind(new_adventure))

func select_adventure(a : Adventure):
	$"../../../Adventure".set_adventure(a)
