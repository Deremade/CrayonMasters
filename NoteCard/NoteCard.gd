class_name NotCard extends Container
# Class: NoteCard
# Extends: Container
# Description: A NoteCard that serves as the main intrface tghe user uses to control characters (Will expand to information abotu characters)
#
# Properties:
#   - TabNode: PackedScene - Preloaded Tab scene, used ot add Tabs
#   - xpand_data: Dictionary - Temporty space holding the actions characters can take, will be replaced with character specific items later
#   - selected: MapItem - The currnely selected item
#   - cols: Dictionary - Holds all the information displayed on the NoteCard
#   - is_targeting: bool - A varibale to know when a suser is targeting so the notecard knows not to update selected
#
# Signals:
#   - none
#
# Dependencies:
#   - $TurnButtom
#   - NoteBook
#
# Usage Notes:
#   - Recives a lot fo signals both automatically and manually set up

var TabNode : PackedScene = load("res://NoteCard/tab.tscn")
var xpand_data = {
	"Inventory" : [Ability.new("Melee Weapon", 1), Ability.new("Ranged Weapon", 10), Ability.new("Health Potion", 1)],
	"Abilities" : ["Dash", "Fire"],
	"Fire" : ["FireBall", "FireWall", "Light Fire"]
}
var selected : MapItem = null
var cols = {
	0 : [],
	1 : [],
	2 : []
}
var is_targeting = false

func _ready():
	$TurnButton.position = Vector2(225, 0)

################################################################################
#Player-NoteBook Interactions

# Function: _on_notebook_select_map_item
# Description: Activates when an item from the notebook is selected
# Parameters:
#   - item: MapItem - The item being clicked on
# Returns: void
# Dependencies: MapItem, Character, Interactable and turn_operations
# Side Effects: Describe any side effects or state changes
# Uses :
#   -_unhandled_input : NoteBook
#
# Modification Guidelines:
#   - Keep in mind : This is a connector function betwen the user's actions, Characters, and The NoteCard
#   - TODO : Move functionality to Paper/Character (especially so that Ability can eb Tile absed instead of Map-Item based)
func _on_notebook_select_map_item(item : MapItem):
	#If the player is using an action that would target what they click on
	if is_targeting:
		#If the item can be targeted use the ability or interact with the item
		if(item.can_target()):
			if(item is Character):
				selected.char_use_ability(item)
			if(item is Interactiable):
				selected.char_interact(item)
		return
	#If there is an already selected item, clear signal connection
	if selected != null :
		selected.change_turn.disconnect(turn_operations)
	#Set the selected item to what is clicked on and make the necessary changes
	selected = item
	selected.change_turn.connect(turn_operations)
	turn_operations(selected.is_turn)
	$RichTextLabel.text = item.char_name

################################################################################
#Player-NoteCard Interactions

# Function: on_expand
# Description: Activated when the user clicks on an "Expand" button
#   - Expands data in a tab to the next collumn
# Parameters:
#   - Data : Array - data held in the tab
#   - col: int - the column number of the next collumn (the one being modifed)
# Returns: void
# Dependencies: clear_col and add_item
# Side Effects: Describe any side effects or state changes
# Example Usage:
#   var result = function_name(param1, param2)
# Uses :
#   -Tab.tscn button mits the "expand" signal
#   -"expand" signal connected in add_item : this file
#
# Modification Guidelines:
#   - This is a middleman to connect a signal to NoteCard update functions (Later in this file)
func on_expand(data, col):
	var row = 0
	clear_col(col)
	for d in data:
		add_item(d, col, row)
		row += 1

# Function: on_check
# Description: Activates when a player clciks a checkmark on the Tab.tscn
#   - Registeres what action the player wants to take based on thier interactions with the Tab.tscn
# Parameters:
#   - data: Generic - Th data or instructions ot be processed
#   - pressed: bool - Weather the box was checked or unchecked
# Returns: void
# Dependencies: selected (var in this file)
# Side Effects:
#   -Sets the is_targeting varibal
#   -Sets is_moving from the character
#   -Activates pllayer_selects_ability and playr_deselects_ability form Character
# Uses :
#   -Tab.tscn button mits the "check" signal
#   -"check" signal connected in add_item : this file
#
# Modification Guidelines:
#   - This is a middleman to connect a signal to Character varibales
#   - Keep the is_targeting function in mind
func on_check(data, pressed):
	#If t he data is not an Ability, handle other possibilities
	if(not data is Ability):
		if(data == "Move"):
			selected.is_moving = pressed
		if(data == "Interact"):
			select_interact(pressed)
	else : #If the data is an ability, set is_targeting and handle character ability selection
		is_targeting = pressed
		if(is_targeting):
			selected.player_selects_ability(data)
		else :
			selected.player_deselects_ability()

# Function: select_interact
# Description: Select the "Interact" option on the NoteCard, allowing interacting with Items
# Parameters:
#   - button_pressed: bool - Was it checked or unchecked
# Returns: void
# Dependencies: InteractableItem, Characer.get_interactables
# Side Effects: sets is_targting and activates IntractbaleItem.player_targeted
# Uses :
#   -on_check : this file
#
# Modification Guidelines:
#   - None
func select_interact(button_pressed):
	is_targeting = true
	for i in selected.get_interactables(1):
		i.player_targeted(true)

################################################################################
#Turn Operations

# Function: _on_turn_button_pressed
# Description: Middleman function connecting the "nd button" to turn operations
# Returns: void
# Dependencies: selected is Character
# Side Effects: sets slected.is_turn to false
# Modification Guidelines:
#   - Remmeber the button signal is manually conencted
func _on_turn_button_pressed():
	selected.is_turn = false
	pass # Replace with function body.

# Function: turn_operations
# Description: Sets up the notecard at the start of a character's turn, and clears it when their turn is over
# Parameters:
#   - is_turn: bool -Is htis the start of or end of a turn
# Returns: void
# Dependencies: add_item and $Button as child node
# Side Effects: clears is_targeting and adds or removes initial tabs
# Uses :
#   -set_turn : Character.gd (via signal connected in _on_notebook_select_map_item : this file)
func turn_operations(is_turn):
	clear_col(0)
	$TurnButton.visible = is_turn
	is_targeting = false
	if is_turn:
		add_item("Move", 0, 0)
		add_item("Interact", 0, 1)
		add_item("Inventory", 0, 2)
		add_item("Abilities", 0, 3)

################################################################################
#Notecard update Functions

# Function: add_item
# Description: Adds a tab to the NoteCard
# Parameters:
#   - item_name: String - Description of parameter
#   - col: int - collumn it is being added to
#   - row: int - row it is being added to
# Returns: void
# Dependencies: List any dependencies or required nodes
# Side Effects: Adds a new Tab to the card and connects the "expand" and "check" singals
# Example Usage:
#   add_item("Move", 0, 0)
# Uses :
#   -turn_operations, on_expand : this file
#
# Modification Guidelines:
#   - Has temperory functionality
func add_item(item_name, col, row):
	#Instanciate the TabNode
	var newTab = TabNode.instantiate()
	#TEMPORARY FUNCTION : adds item basd on predefined data (defined in xpand_data)
	if xpand_data.has(item_name):
		newTab.set_tab_vars(item_name, true, xpand_data[item_name])
	else :
		newTab.set_tab_vars(item_name, false, [])
	#set the TabNode position
	newTab.position = Vector2i(96*col, 32+(32*row))
	#Connect the appropriate signals
	newTab.connect("expand", on_expand.bind(col+1))
	newTab.connect("check", on_check)
	
	add_child(newTab)
	cols[col].append(newTab)

# Function: clear_col
# Description: Clears a collumn
# Parameters:
#   - num : int - Description of parameter
# Returns: void
# Dependencies: none
# Side Effects: Deletes TabNodes
# Example Usage:
#   clear_col(0)
# Uses :
#   -on_expand, add_item : this file
#
# Modification Guidelines:
#   - Is recursive function
func clear_col(num):
	#If there is nothing to clear, do nothing
	if(not cols.has(num)):
		return
	#clear the next collumn bfore proceeding
	clear_col(num+1)
	#Remove all items in this collumn
	for item in cols[num]:
		remove_child(item)
	cols[num] = []
