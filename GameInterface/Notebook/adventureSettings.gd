extends Node2D

var cur_adventure : Adventure
@onready var events = $Events
@onready var update_characters = Callable(events, "update_adventure_characters")

func set_adventure(a : Adventure):
	if(not cur_adventure == null):
		cur_adventure.disconnect("characters_updated", update_characters)
	$"../../TabBar".set_tab_disabled(3, false)
	cur_adventure = a
	$"Adventure Name".text = "[b]"+str(a.name)+"[/b]"
	cur_adventure.characters_updated.connect(update_characters)
