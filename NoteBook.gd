class_name Notebook
extends Node2D

# Class: Notebook
# Extends: Node2D
# Description: The basic Interface for the game (within a setting)
#
# Properties:
#   - cur_tab: int - Description
#   - cur_tabMarker: Node - Current tab marker, used mostly for visual charm
#   - cur_Page: Node - Current "Page" based on the tab Marker, displays current relevant information
#
# Signals:
#   - none
#
# Dependencies:
#   - BattleMap
#
# Usage Notes:
#   - Is the notebook that contains setting/genre
#   - Limited size may want to do something about that
#   - Might want to check if invisible nodes still "process" things

# Scene: SceneName
# Path: res://path/to/scene.tscn
# 
# Purpose:
#   Is the Main interface for the actual gameplay
#
# Required Nodes:
#   - $Cover: Displays when book is closed
#   - $Pages: Holds the pages and displays hwen book is opened
#   - $Close: Closes the book
#
# Signals Connected:
#   - From -> To: Description of connection
#
# Scene Tree Structure:
#   Root
#   ├── Tabs [Selected by the player, mcved around for immersion]
#   └── Cover 
#   └── Close [closes the notebook to select annother setting] 
#   └── Pages
#      └── Battle
#          └── BattleMap
#
# Modification Guidelines:
#   - Remmeber what starts hidden or visible
#
# TODO:
#   - Group Tabs under 1 node
#   - Make Setting specific (when you get around to settings)

var cur_tab = 0
var cur_tabMarker = null
var cur_Page = null

# Function: open_book
# Description: Opens the Notebook
# Dependencies: $Cover, $Pages, $Close
# Side Effects: Hides the Cover, reveals Pages and close
# Uses :
#   -open_tab : This file
#
# Modification Guidelines:
#   - NA
func open_book():
	$Cover.visible = false
	$Pages.visible = true
	$Close.visible = true

# Function: open_tab
# Description: Opens a tab of the notebook
# Parameters:
#   - tab: int - The numerical position of the tab (from the top goin down)
# Dependencies: Depends on all tabs, open_book
# Side Effects: Moves all tabs above the current tab marker to the left, 
#			brings current tab marker to front
# Example Usage:
#   open_tab(0) #Opens top tab
# Uses :
#   -Signal from buttons which are the child nodes of the tab markers
#
# Modification Guidelines:
#   - If parameters are changed :" make sure to update the signals
#   - Perfect flipping is finiky
func open_tab(tab : int):
	open_book()
	if not cur_tabMarker == null :
		cur_tabMarker.z_index = 0
	
	#If tab s greater than current tab
	for i in range(cur_tab, tab):
		var flip_marker = get_child(i)
		flip_marker.position.x *= -1
		flip_marker.scale.y *= -1
		flip_marker.get_child(0).scale.x *= -1
		flip_marker.get_child(0).rotation += PI
	
	#If tab is less than cur_tab
	for i in range(tab, cur_tab):
		var flip_marker = get_child(i)
		flip_marker.position.x *= -1
		flip_marker.scale.y *= -1
		flip_marker.get_child(0).scale.x *= -1
		flip_marker.get_child(0).rotation += PI
	
	#Deal with current tab
	cur_tabMarker = get_child(tab)
	cur_tabMarker.z_index = 1
	if(cur_Page):
		cur_Page.visible = false
	cur_Page = $Pages.get_child(tab)
	cur_Page.visible = true
	cur_tab = tab

# Function: close_book
# Description: Closes the Notebook
# Dependencies: $Cover, $Pages, $Close, open_tab
# Side Effects: Reveals the Cover, hides Pages and Close, moves current tab marker back in z_index
# Uses :
#   -signal from $Close/Close
#
# Modification Guidelines:
#   - NA
func close_book():
	open_tab(0)
	cur_tabMarker.z_index = 0
	$Cover.visible = true
	$Pages.visible = false
	$Close.visible = false
