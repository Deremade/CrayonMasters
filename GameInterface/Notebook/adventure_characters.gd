extends Control
#TODO : Replace with better interface
#Preload notecard to edit characters
var char_editor = preload("res://GameInterface/NoteCards/notecard_button.tscn")

func _on_button_pressed() -> void:
	#Name
	var char_name = $TextEdit.text
	#Create new Character
	var new_char = Character.new()
	new_char.char_name = char_name
	#Creaet notecard editor
	var char_edit = char_editor.instantiate()
	char_edit.text = char_name
	#Get notecard
	var notecard : NoteCard = char_edit.get_child(0)
	#Set character hat
	notecard.add_color_picker("Hat Color")
	notecard.add_dropdown("Hat", [
		ImageTexture.create_from_image(Image.load_from_file("res://Sprites/CharImgs/StickFigures/AtompunkHelm.png")),
		ImageTexture.create_from_image(Image.load_from_file("res://Sprites/CharImgs/StickFigures/WizHat.png")),
		ImageTexture.create_from_image(Image.load_from_file("res://Sprites/CharImgs/StickFigures/CoyboyHat.png"))
	])
	#Inventory
	notecard.add_text("Inventory")
	notecard.add_checkbox("Sword")
	notecard.add_checkbox("Raygun")
	notecard.add_checkbox("Pistol")
	notecard.add_checkbox("Shirkien")
	#Abiltiies
	notecard.add_text("Abilities")
	notecard.add_checkbox("Freeze")
	notecard.add_checkbox("Fireball")
	notecard.add_checkbox("Lightning")
	#Add notecard
	$VBoxContainer.add_child(char_edit)
	$"..".cur_adventure.add_character(new_char)
	char_edit.connect_changes_signal(new_char, "build_from_settings")
