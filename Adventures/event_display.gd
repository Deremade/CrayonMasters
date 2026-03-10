# Scene: event_display
# Path: res://Adventures/event_display.tscn
#Node Path :Open/Adventure/Events/VBoxContainer/event_display.tscn
# 
# Purpose:
#   Displays an Event in a list
#
# Required Nodes:
#   - NodePath: Purpose of this node
#   - NodePath: Purpose of this node
#
# Signals Connected:
#   - From : EnterButton -> To: event_display.gd:_on_enter_button_pressed
#
# Scene Tree Structure:
#   Root
#   ├── Img
#   ├── RichTextLabel
#   ├── NotecardButrton
#   └── EnterButton
#
# Modification Guidelines:
#   - NoteCardButton is it's own Node
#   - NoteCardButton also contains most of the Settings
#
# TODO:
#   - Move from notecard form into a whole page (or new kind of notecard form)

extends Control
#Signal to enter the event displayed
signal enter_event

func _ready() -> void:
	#Move the notecard overa bit [looks better this way]
	$NotecardButton/NoteCard.position.x -= 100
#The event this display displays
var event : Event = null:
	set(e):
		event = e
		$RichTextLabel.text = "[b]"+event.event_name+"[/b]"
		e.finish_event.connect(Callable(self, "viewable"))

#Update the characters based on characters updated in the setting
func update_characters(chars):
	var notecard : NoteCard = $NotecardButton.get_child(0)
	$NotecardButton.connect_changes_signal(event, "incorperate_settings")
	#Clear the card to reset
	notecard.clear_card()
	#add eery character to the card
	for c : Character in chars:
		notecard.add_num_input(c.char_name + " : Team ", 0, 2)

func _on_enter_button_pressed() -> void:
	enter_event.emit(event)
	pass
#Set the event as viewable or unviewable
func viewable():
	event.notecard_log($NotecardButton.get_child(0))
	$NotecardButton.text = "View"
	$EnterButton.disabled = true
