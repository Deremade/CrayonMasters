class_name CombatEvent extends Event
#For each character in chars_invovled [parent class], assigns team 1 or team 2
var team : Array[int]

#function to add all characters to the event, used in build_event
func add_characters(EventNode : Node):
	for i in range(0, len(chars_involed)):
		EventNode.add_character(chars_involed[i], team[i], false)
		pass

#Function to incorperate settings given in dictionary form
#Extended function from Event
#Called in event_display.gd
func incorperate_settings(settings : Dictionary):
	#Clear everything
	chars_involed.clear()
	team.clear()
	#Add every character based on the settings
	for c : Character in adventure.Characters:
		if settings.has(c.char_name + " : Team "):
			if settings[c.char_name + " : Team "] != 0:
				chars_involed.append(c)
				team.append(int(settings[c.char_name + " : Team "]))

#Function to build the event
#called in adventure_event.gd
func build_event(eventNode : Node):
	#Clear previous event
	for c in eventNode.get_children():
		eventNode.remove_child(c)
	#add characters
	add_characters(eventNode)
	#Set first turn and set current event to self
	eventNode.cur_turn = eventNode.get_child(0)
	eventNode.cur_event = self
