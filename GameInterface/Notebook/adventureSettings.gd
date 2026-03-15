extends Node2D
#Current Adventure being edited
var cur_adventure : Adventure
@onready var events = $Events
@onready var update_characters = Callable(events, "update_adventure_characters")

func set_adventure(a : Adventure):
	#remove signals from previous adventure
	if(not cur_adventure == null):
		cur_adventure.disconnect("characters_updated", update_characters)
	#Enable adventure tab
	$"../../TabBar".set_tab_disabled(3, false)
	#Set the current adventure
	cur_adventure = a
	$"Adventure Name".text = "[b]"+str(a.name)+"[/b]"
	cur_adventure.characters_updated.connect(update_characters)
