extends Node2D
var open = false

# Function: _on_tab_mouse_entered
# Description: Opens the Options notecard from the file tab
# Parameters:
#   - tab_color: Color - The color of the tab, which is used to ch
#   - tab: int - Used to change contents of the card (Number for optimization purposes)
# Dependencies: ColorRect and it's three chld nodes : General, Audio, Graphics
# Side Effects: moves the card down into visibility
# Uses :
#   -Called based on signal of the mouse moving into a tab
#
# Modification Guidelines:
#   - Nodes under ColorRect are made visibile or invisible to change the content
func _on_tab_mouse_entered(tab_color : Color, tab : int):
	#Change color
	$ColorRect.color = tab_color
	#Move the card into visible range
	position.y = 0
	open = true
	#Change the content
	$ColorRect/General.visible = (tab == 0)
	$ColorRect/Audio.visible = (tab == 1)
	$ColorRect/Graphics.visible = (tab == 2)

# Function: function_name
# Description: Brief description of what the function does
# Side Effects: Moves the card upwards to remove it from visible range
# Uses :
#   -_unhandled_input in this file (in case the signal fails)
#   - Signal mouse_exit from ColorRect
#
# Modification Guidelines:
#   - May want to remove signal and keep unhandled input or optimize the signal
func _on_page_mouse_exited():
	position.y = -128
	open = false

# Function: _on_quit_button_pressed
# Description: Quits the games
# Side Effects: Quits th egame
# Example Usage:
#   var result = function_name(param1, param2)
# Uses :
#   -Signal from The ColorRect/General Tab (The QuitButton Node)
func _on_quit_button_pressed():
	get_tree().quit()

# Function: _unhandled_input
# Description: used to close the OptionsMenu when the mouse moves ot of range
# Parameters:
#   - event : ? - Input Event
# Dependencies: _on_page_mouse_exited (this file)
# Side Effects: Moves the card back out of visible range
func _unhandled_input(event):
	if(open):
		if(event is InputEventMouseMotion):
			if(get_global_mouse_position().x > 320 || get_global_mouse_position().y > 128):
				_on_page_mouse_exited()

# Function: _on_report_bug_pressed
# Description: Toggles the Report bug screen
# Dependencies: BugReport Node
# Side Effects: Toggles the BugReport Node visibility
# Uses :
#   -Signal From General options
#   -Signal from child Node of BugReport (ReportBug)
# Modification Guidelines:
#   - Turns the bug reprot on or off, does not do anything else
func _on_report_bug_pressed():
	$BugReport.visible = not $BugReport.visible
