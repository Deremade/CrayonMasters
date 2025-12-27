class_name statEffect extends Resource
@export var stacks : int = 1

func start_turn_effect(charactr : Character):
	pass

func start_turn_graphic(char_drawing : CharacterDrawing):
	await char_drawing.status_message("Status effect")

func end_turn_effect():
	stacks -= 1;
	pass

class Stun extends statEffect:
	
	func start_turn_effect(charactr : Character):
		pass
	
	func start_turn_graphic(char_drawing : CharacterDrawing):
		char_drawing.actions = 0
		await char_drawing.status_message("Stunned")
