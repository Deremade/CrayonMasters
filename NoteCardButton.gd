extends Button

func _ready():
	$NoteCard/NoteCardTitle.text = "[b]"+self.text+"[/b]"

func _on_pressed():
	$NoteCard.visible = true

func get_notecard_chnages() -> Dictionary:
	return $NoteCard.changes
