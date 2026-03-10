extends Control

static var sagas = {}
var cur_saga = ""
#New Saga button : Notebook/Stories/SelectAdventure/Sagas/Button
func _on_button_pressed() -> void:
	#give error if no name was provided
	if $TextEdit.text == "" :
		Game.err_sticker("Please enter a name for the new Saga",self)
		return
	#Make a button to enter the new saga
	var new_saga = Button.new()
	new_saga.text = $TextEdit.text
	new_saga.pressed.connect(Callable(self, "open_saga").bind($TextEdit.text))
	#Make list of adventures
	sagas[$TextEdit.text] = []
	$List.add_child(new_saga)
	#Clear name input
	$TextEdit.text = ""
#Add an adventure to the cur_saga
func add_adventure(adventure_name):
	sagas[cur_saga].append(adventure_name)

func open_saga(saga_name):
	#Enable Advenutre interface in this saga
	$"../Adventures".visible = true
	cur_saga = saga_name
	#Clear all current adventures in the next page
	for c in $"../Adventures/List".get_children():
		$"../Adventures/List".remove_child(c)
	#List all current adventures
	for a in sagas[saga_name]:
		var adventure_button = Button.new()
		adventure_button.text = a.name
		#Connect clicking on the button to 'select adventure' button
		a.pressed.connect(Callable(self, "select_adventure").bind(a))
		$"../Adventures/List".add_child(adventure_button)
	pass

func select_adventure(a : Adventure):
	$"../../../Adventure".set_adventure(a)
