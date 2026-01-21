extends Control
var selected_saga

static var sagas = {}
var cur_saga = ""
func _on_button_pressed() -> void:
	if $TextEdit.text == "" :
		Game.err_sticker("Please enter a name for the new Saga",self)
		return
	var new_saga = Button.new()
	new_saga.text = $TextEdit.text
	sagas[$TextEdit.text] = []
	new_saga.pressed.connect(Callable(self, "open_saga").bind($TextEdit.text))
	$TextEdit.text = ""
	$List.add_child(new_saga)

func add_adventure(name):
	sagas[cur_saga].append(name)

func open_saga(saga_name):
	$"../Adventures".visible = true
	cur_saga = saga_name
	for c in $"../Adventures/List".get_children():
		$"../Adventures/List".remove_child(c)
	for a in sagas[saga_name]:
		$"../Adventures/List".add_child(a.get_button())
	pass
