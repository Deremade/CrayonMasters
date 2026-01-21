class_name Event extends Resource

var chars_involed : Array[Character]
var sides : Array[int]
var event_name
var adventure : Adventure
var open : bool = true
var log : Array[String] = []
signal finish_event

func _init(set_name, set_adventure):
	event_name = set_name
	adventure = set_adventure

func incorperate_settings(settings : Dictionary):
	chars_involed.clear()
	sides.clear()
	for c : Character in adventure.Characters:
		if settings.has(c.char_name + " : Team "):
			if settings[c.char_name + " : Team "] != 0:
				chars_involed.append(c)
				sides.append(int(settings[c.char_name + " : Team "]))
	print(chars_involed)
	print(sides)

func build_event(eventNode : Node):
	for c in eventNode.get_children():
		eventNode.remove_child(c)
	print(len(chars_involed))
	for i in len(chars_involed):
		eventNode.add_character(chars_involed[i], sides[i])
	eventNode.cur_turn = eventNode.get_child(0)
	eventNode.cur_event = self

func log_sub_event(sub_event : String):
	log.append(sub_event)

func notecard_log(card : NoteCard):
	card.clear_card()
	for l in log:
		card.add_text(l)
