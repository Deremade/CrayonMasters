class_name Event extends Resource

#Characters involved in the event
var chars_involed : Array[Character]
var event_name
#Convienient access to the Adventure functions and properties [Mostly used to get characters]
var adventure : Adventure
var open : bool = true
#Record Keeeping function, Will allow the event to be read by player
var eventLog : Array[String] = []
@warning_ignore("unused_signal")
signal finish_event #Used to activate the viewable function in event_display.gd

func _init(set_event_name, set_adventure):
	event_name = set_event_name
	adventure = set_adventure

#Incoperates a dictionary of settings to build the event
#Only defined in subclasses since Cambat vs NonCombat drstically change implementation
func incorperate_settings(_settings : Dictionary):
	pass

func build_event(_eventNode : Node):
	pass

#Adds a sub event to the log dor record keeping
func log_sub_event(sub_event : String):
	eventLog.append(sub_event)

#Modifies a notecard to display the log
func notecard_log(card : NoteCard):
	card.clear_card()
	for l in eventLog:
		card.add_text(l)
