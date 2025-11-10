extends Control

var ability : Ability
signal using_ability(toggle : bool, ability: Ability)

func _ready():
	pass

func set_ability(sability : Ability):
	ability = sability
	$RichTextLabel.text = "[b]"+ability.name+"[/b]"
	$Img.scale.x = 64.0/ability.texture.get_height()
	$Img.scale.y = 64.0/ability.texture.get_width()
	$Img.texture = ability.texture
	var note_Card : NoteCard = $Button/NoteCard
	for setting in ability.settings:
		var value = ability.settings[setting]
		if(value is bool):
			if(value):
				note_Card.add_checkbox(setting)
			else :
				note_Card.add_text(setting)
		else:
			if value[0] is int:
				note_Card.add_num_input(setting, value[0], value[1])
			else:
				note_Card.add_dropdown(setting, value)


func _on_check_box_toggled(button_pressed):
	ability.changes = $Button.get_notecard_chnages()
	using_ability.emit(button_pressed, ability)
	
