class_name Frozen extends statEffect

func start_turn_effect(charactr : Character):
	pass

func start_turn_graphic(char_drawing : CharacterDrawing):
	char_drawing.actions = 0
	await char_drawing.status_message("Frozen")
