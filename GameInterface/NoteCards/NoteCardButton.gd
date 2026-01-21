extends Button

func _ready():
	$NoteCard/NoteCardTitle.text = "[b]"+self.text+"[/b]"

func _on_pressed():
	$NoteCard.visible = true
	$NoteCard.z_index = RenderingServer.CANVAS_ITEM_Z_MAX

func connect_changes_signal(script, call_function : String):
	$NoteCard.made_changes.connect(Callable(script, call_function))
