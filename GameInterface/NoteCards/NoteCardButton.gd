extends Button

func _ready():
	$NoteCard/NoteCardTitle.text = "[b]"+self.text+"[/b]"
#When the button is pressed, the notecard is visible
func _on_pressed():
	$NoteCard.visible = true
	$NoteCard.z_index = RenderingServer.CANVAS_ITEM_Z_MAX

#Connect the "make_changes" singal to a dunction of your choice
#make_changes signal comes with a dicitonary of all changes
func connect_changes_signal(script, call_function : String):
	$NoteCard.made_changes.connect(Callable(script, call_function))
