extends Control

##Move NotePad
var local_mouse_rel  # Local mouse position relative to the window
var drag = false  # Flag to indicate if dragging is in progress
var character : Character = null
signal using_ability(toggle : bool, ability : Ability)

func _process(_delta):
	if(drag):
		global_position = get_global_mouse_position()-local_mouse_rel

func _on_panel_gui_input(event):
	if event is InputEventMouseButton :
		if event.pressed && event.button_index == 1:
			drag = true  # Start dragging when the mouse button is pressed
			local_mouse_rel = get_local_mouse_position()  # Set the local mouse position for dragging
		else :
			drag = false  # Stop dragging when th

func _on_tab_bar_tab_clicked(tab):
	if tab == 5 : visible = false
	$Main.visible = tab == 0
	$Abilities.visible = tab == 1
	$Inventory.visible = tab == 2
	$Mind.visible = tab == 3
	$Log.visible = tab == 4

#Receives signal from Character_Drawing
func _on_name_tag_pressed():
	visible = true
	position = Vector2(-360, -80)
	_on_tab_bar_tab_clicked(0)


func set_char(set_character : Character):
	character = set_character
	$CharacterName.text = "[b]"+character.char_name+"[/b]"
	$Main/ProfPic.texture = character.profile_pic
	$Inventory/StickyNote.set_ability(set_character.inventory[0])


func _on_sticky_note_using_ability(toggle, ability):
	using_ability.emit(toggle, ability)
