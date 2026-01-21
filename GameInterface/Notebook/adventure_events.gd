extends Control

var event_display = preload("res://Adventures/event_display.tscn")

func _on_button_pressed() -> void:
	var new_event = Event.new($TextEdit.text, $"..".cur_adventure)
	var new_event_display = event_display.instantiate()
	new_event_display.event = new_event
	new_event_display.update_characters($"..".cur_adventure.Characters)
	$"..".cur_adventure.characters_updated.connect(Callable(new_event_display, "update_characters"))
	$VBoxContainer.add_child(new_event_display)
	new_event_display.enter_event.connect(Callable(self, "enter_event"))

func enter_event(e : Event):
	e.build_event($"../../Event/Battle")
	$"../../../TabBar".set_tab_disabled(4, false)
