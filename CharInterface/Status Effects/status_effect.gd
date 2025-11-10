class_name statEffect extends Resource
@export var stacks : int = 1

func start_turn_effect(charactr : Character):
	pass

func end_turn_effect():
	stacks -= 1;
	pass

class Stun extends statEffect:
	
	func start_turn_effect(charactr : Character):
		print(charactr.char_name, " is stunned")
		charactr.actions = 0

class Frozen extends statEffect:
	
	func _init(init_stacks : int):
		stacks = init_stacks

	func start_turn_effect(charactr : Character):
		charactr.actions = 0
