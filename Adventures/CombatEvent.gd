class_name CombatEvent extends Event

var team : Array[int]

func add_characters(EventNode : Node):
	for i in range(0, len(chars_involed)):
		EventNode.add_character(chars_involed[i], team[i], false)
		pass
