extends Control
signal enter_event

func _ready() -> void:
	$NotecardButton/NoteCard.position.x -= 100
var event : Event = null:
	set(e):
		event = e
		$RichTextLabel.text = "[b]"+event.event_name+"[/b]"
		e.finish_event.connect(Callable(self, "viewable"))

func update_characters(chars):
	var notecard : NoteCard = $NotecardButton.get_child(0)
	$NotecardButton.connect_changes_signal(event, "incorperate_settings")
	notecard.clear_card()
	for c : Character in chars:
		notecard.add_num_input(c.char_name + " : Team ", 0, 2)

func _on_enter_button_pressed() -> void:
	enter_event.emit(event)
	pass # Replace with function body.

func viewable():
	event.notecard_log($NotecardButton.get_child(0))
	$NotecardButton.text = "View"
	$EnterButton.disabled = true
